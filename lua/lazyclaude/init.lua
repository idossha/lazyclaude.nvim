local window = require("lazyclaude.window")

local M = {}

---@class LazyclaudeConfig
---@field lazyclaude_cmd string Path or command name for the lazyclaude binary
---@field floating_window_scaling_factor number Window size relative to editor (0.0-1.0)
---@field floating_window_winblend number Window transparency (0-100)
---@field floating_window_border string|table Border style ("none","single","double","rounded","solid","shadow" or char list)
---@field project_dir? string Override project directory passed to lazyclaude
---@field claude_dir? string Override claude directory passed to lazyclaude
---@field on_open? fun(term: table) Callback when lazyclaude opens
---@field on_exit? fun(code: number) Callback when lazyclaude exits

---@type LazyclaudeConfig
local defaults = {
  lazyclaude_cmd = "lazyclaude",
  floating_window_scaling_factor = 0.9,
  floating_window_winblend = 0,
  floating_window_border = "rounded",
  project_dir = nil,
  claude_dir = nil,
  on_open = nil,
  on_exit = nil,
}

---@type LazyclaudeConfig
M.config = vim.deepcopy(defaults)

-- State
local state = {
  buf = nil,
  win = nil,
  job_id = nil,
}

--- Reset internal state to idle.
local function reset_state()
  state.buf = nil
  state.win = nil
  state.job_id = nil
end

--- Check if the lazyclaude window is currently open and valid.
---@return boolean
local function is_open()
  return state.win ~= nil and vim.api.nvim_win_is_valid(state.win)
end

--- Check if the lazyclaude buffer is currently valid.
---@return boolean
local function buf_valid()
  return state.buf ~= nil and vim.api.nvim_buf_is_valid(state.buf)
end

--- Build the shell command to invoke lazyclaude.
---@param config LazyclaudeConfig
---@param opts? {project_dir?: string} Per-call overrides
---@return string
local function build_cmd(config, opts)
  opts = opts or {}
  local cmd = config.lazyclaude_cmd

  if config.claude_dir then
    cmd = cmd .. " --claude-dir " .. vim.fn.shellescape(config.claude_dir)
  end

  local project = opts.project_dir or config.project_dir
  if project then
    cmd = cmd .. " --project-dir " .. vim.fn.shellescape(project)
  end

  return cmd
end

--- Clean up window and buffer, then reset state.
local function cleanup()
  if is_open() then
    vim.api.nvim_win_close(state.win, true)
  end
  if buf_valid() then
    vim.api.nvim_buf_delete(state.buf, { force = true })
  end
  reset_state()
end

--- Check if lazyclaude binary is available.
---@return boolean
function M.is_available()
  return vim.fn.executable(M.config.lazyclaude_cmd) == 1
end

--- Open lazyclaude in a floating terminal.
---@param opts? {project_dir?: string} Per-call overrides
function M.open(opts)
  opts = opts or {}

  if not M.is_available() then
    vim.notify(
      "lazyclaude: '" .. M.config.lazyclaude_cmd .. "' not found. Install it or set lazyclaude_cmd in setup().",
      vim.log.levels.ERROR
    )
    return
  end

  -- If existing window is valid, focus it
  if is_open() then
    vim.api.nvim_set_current_win(state.win)
    vim.cmd("startinsert")
    return
  end

  -- Clean up any stale state from a previous session
  if state.buf or state.win then
    cleanup()
  end

  local buf, win = window.open_floating_window(M.config)
  state.buf = buf
  state.win = win

  local cmd = build_cmd(M.config, opts)

  -- Set EDITOR=nvim so lazyclaude opens files in Neovim with user config
  local env = { EDITOR = "nvim" }

  local ok, job_id = pcall(vim.fn.termopen, cmd, {
    env = env,
    on_exit = function(_, code, _)
      vim.schedule(function()
        cleanup()
        if M.config.on_exit then
          M.config.on_exit(code)
        end
      end)
    end,
  })

  if not ok or job_id <= 0 then
    vim.notify("lazyclaude: failed to start terminal: " .. tostring(job_id), vim.log.levels.ERROR)
    cleanup()
    return
  end

  state.job_id = job_id

  -- Handle buffer being wiped externally (e.g. :bdelete)
  vim.api.nvim_create_autocmd("BufWipeout", {
    buffer = buf,
    once = true,
    callback = function()
      reset_state()
    end,
  })

  vim.cmd("startinsert")

  if M.config.on_open then
    M.config.on_open({ buf = buf, win = win })
  end
end

--- Open lazyclaude scoped to the current file's project.
function M.open_current_project()
  local bufname = vim.api.nvim_buf_get_name(0)
  local project_dir

  if bufname ~= "" then
    project_dir = vim.fn.fnamemodify(bufname, ":p:h")
    local git_root =
      vim.fn.systemlist("git -C " .. vim.fn.shellescape(project_dir) .. " rev-parse --show-toplevel")[1]
    if vim.v.shell_error == 0 and git_root and git_root ~= "" then
      project_dir = git_root
    end
  end

  M.open({ project_dir = project_dir })
end

--- Close lazyclaude if open.
function M.close()
  cleanup()
end

--- Toggle lazyclaude open/closed.
function M.toggle()
  if is_open() then
    M.close()
  else
    M.open()
  end
end

--- Setup the plugin with user configuration.
---@param opts? LazyclaudeConfig
function M.setup(opts)
  M.config = vim.tbl_deep_extend("force", vim.deepcopy(defaults), opts or {})

  -- Clamp scaling factor
  M.config.floating_window_scaling_factor =
    math.max(0.1, math.min(1.0, M.config.floating_window_scaling_factor))
end

return M
