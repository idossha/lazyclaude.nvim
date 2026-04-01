local M = {}

local MIN_WIDTH = 40
local MIN_HEIGHT = 10

--- Calculate floating window position and dimensions.
---@param config table Plugin configuration
---@return table {width: number, height: number, row: number, col: number}
function M.get_window_pos(config)
  local factor = config.floating_window_scaling_factor
  local columns = vim.o.columns
  local lines = vim.o.lines

  local width = math.max(MIN_WIDTH, math.floor(columns * factor))
  local height = math.max(MIN_HEIGHT, math.floor(lines * factor))

  -- Clamp to editor bounds
  width = math.min(width, columns)
  height = math.min(height, lines - 2) -- leave room for cmdline

  local col = math.floor((columns - width) / 2)
  local row = math.floor((lines - height) / 2 - 1)

  if row < 0 then
    row = 0
  end

  return { width = width, height = height, row = row, col = col }
end

--- Open a floating window with a terminal buffer.
---@param config table Plugin configuration
---@return number buf Buffer handle
---@return number win Window handle
function M.open_floating_window(config)
  local pos = M.get_window_pos(config)

  local buf = vim.api.nvim_create_buf(false, true)

  local win_opts = {
    relative = "editor",
    width = pos.width,
    height = pos.height,
    row = pos.row,
    col = pos.col,
    style = "minimal",
    border = config.floating_window_border,
  }

  local win = vim.api.nvim_open_win(buf, true, win_opts)

  vim.api.nvim_set_option_value("winblend", config.floating_window_winblend, { win = win })

  -- Resize handler
  local resize_group = vim.api.nvim_create_augroup("LazyclaudeResize", { clear = true })
  vim.api.nvim_create_autocmd("VimResized", {
    group = resize_group,
    callback = function()
      if not vim.api.nvim_win_is_valid(win) then
        return true -- remove autocmd
      end
      local new_pos = M.get_window_pos(config)
      vim.api.nvim_win_set_config(win, {
        relative = "editor",
        width = new_pos.width,
        height = new_pos.height,
        row = new_pos.row,
        col = new_pos.col,
      })
    end,
  })

  return buf, win
end

return M
