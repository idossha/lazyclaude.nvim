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
local lazyclaude_buf = nil
local lazyclaude_win = nil

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
    vim.notify("lazyclaude: binary not found: " .. M.config.lazyclaude_cmd, vim.log.levels.ERROR)
    return
  end

  -- If existing window is valid, focus it
  if lazyclaude_win and vim.api.nvim_win_is_valid(lazyclaude_win) then
    vim.api.nvim_set_current_win(lazyclaude_win)
    return
  end

  local buf, win = window.open_floating_window(M.config)
  lazyclaude_buf = buf
  lazyclaude_win = win

  local cmd = build_cmd(M.config, opts)

  vim.fn.termopen(cmd, {
    on_exit = function(_, code, _)
      -- Clean up
      if lazyclaude_win and vim.api.nvim_win_is_valid(lazyclaude_win) then
        vim.api.nvim_win_close(lazyclaude_win, true)
      end
      lazyclaude_buf = nil
      lazyclaude_win = nil

      if M.config.on_exit then
        M.config.on_exit(code)
      end
    end,
  })

  vim.cmd("startinsert")

  if M.config.on_open then
    M.config.on_open({ buf = buf, win = win })
  end
end

--- Open lazyclaude scoped to the current file's project.
function M.open_current_project()
  local project_dir = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":p:h")
  -- Walk up to find a git root
  local git_root = vim.fn.systemlist("git -C " .. vim.fn.shellescape(project_dir) .. " rev-parse --show-toplevel")[1]
  if vim.v.shell_error == 0 and git_root and git_root ~= "" then
    project_dir = git_root
  end
  M.open({ project_dir = project_dir })
end

--- Close lazyclaude if open.
function M.close()
  if lazyclaude_win and vim.api.nvim_win_is_valid(lazyclaude_win) then
    vim.api.nvim_win_close(lazyclaude_win, true)
  end
  lazyclaude_buf = nil
  lazyclaude_win = nil
end

--- Toggle lazyclaude open/closed.
function M.toggle()
  if lazyclaude_win and vim.api.nvim_win_is_valid(lazyclaude_win) then
    M.close()
  else
    M.open()
  end
end

--- Setup the plugin with user configuration.
---@param opts? LazyclaudeConfig
function M.setup(opts)
  M.config = vim.tbl_deep_extend("force", vim.deepcopy(defaults), opts or {})
end

return M
