local M = {}

function M.check()
  vim.health.start("lazyclaude.nvim")

  -- Check Neovim version
  if vim.fn.has("nvim-0.9") == 1 then
    vim.health.ok("Neovim >= 0.9")
  else
    vim.health.error("Neovim >= 0.9 required")
  end

  -- Check lazyclaude binary
  local config = require("lazyclaude").config
  local cmd = config.lazyclaude_cmd
  if vim.fn.executable(cmd) == 1 then
    local version = vim.fn.system(cmd .. " --version"):gsub("%s+$", "")
    vim.health.ok("Found `" .. cmd .. "`: " .. version)
  else
    vim.health.error("`" .. cmd .. "` not found in $PATH", {
      "Install lazyclaude: https://github.com/idossha/lazyclaude",
      'Or set a custom path: require("lazyclaude").setup({ lazyclaude_cmd = "/path/to/lazyclaude" })',
    })
  end
end

return M
