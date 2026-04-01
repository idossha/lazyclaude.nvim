if vim.g.loaded_lazyclaude then
  return
end
vim.g.loaded_lazyclaude = true

vim.api.nvim_create_user_command("LazyClaude", function()
  require("lazyclaude").open()
end, { desc = "Open lazyclaude TUI" })

vim.api.nvim_create_user_command("LazyClaudeCurrentProject", function()
  require("lazyclaude").open_current_project()
end, { desc = "Open lazyclaude scoped to current file's project" })

vim.api.nvim_create_user_command("LazyClaudeToggle", function()
  require("lazyclaude").toggle()
end, { desc = "Toggle lazyclaude TUI" })

vim.api.nvim_create_user_command("LazyClaudeClose", function()
  require("lazyclaude").close()
end, { desc = "Close lazyclaude TUI" })
