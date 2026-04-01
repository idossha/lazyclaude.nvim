-- Minimal Neovim config for the lazyclaude.nvim demo recording.
-- Usage: nvim --clean -u demo/init.lua

-- Resolve paths relative to this file
local demo_dir = vim.fn.fnamemodify(debug.getinfo(1, "S").source:sub(2), ":p:h")
local repo_root = vim.fn.fnamemodify(demo_dir, ":h")

-- Add the plugin to runtimepath
vim.opt.rtp:prepend(repo_root)

-- Basic appearance
vim.o.termguicolors = true
vim.o.number = true
vim.o.signcolumn = "no"
vim.o.showmode = false
vim.o.laststatus = 2
vim.o.statusline = " %f %=%l:%c "

-- Configure the plugin with demo data paths
require("lazyclaude").setup({
  claude_dir = demo_dir .. "/claude-home",
  project_dir = demo_dir .. "/project",
  floating_window_scaling_factor = 0.85,
  floating_window_border = "rounded",
})

-- Set the keybinding used in the demo
vim.keymap.set("n", "<leader>lc", "<cmd>LazyClaude<cr>", { desc = "LazyClaude" })
