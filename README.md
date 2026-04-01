# lazyclaude.nvim

A Neovim plugin that wraps [lazyclaude](https://github.com/idohaber/lazyclaude) in a floating terminal window, similar to how [lazygit.nvim](https://github.com/kdheepak/lazygit.nvim) wraps lazygit.

## Requirements

- Neovim >= 0.9
- [lazyclaude](https://github.com/idohaber/lazyclaude) installed and on your `$PATH`

## Installation

### [lazy.nvim](https://github.com/folke/lazy.nvim)

```lua
{
  "idohaber/lazyclaude",
  keys = {
    { "<leader>lc", "<cmd>LazyClaude<cr>", desc = "LazyClaude" },
  },
  config = function()
    require("lazyclaude").setup()
  end,
}
```

> **Note:** If using a monorepo structure where the plugin lives at `lazyclaude.nvim/` within the main repo, point lazy.nvim to the subdirectory:
>
> ```lua
> {
>   "idohaber/lazyclaude",
>   dir = "lazyclaude.nvim",  -- or use the full path
>   -- ...
> }
> ```

### [packer.nvim](https://github.com/wbthomason/packer.nvim)

```lua
use {
  "idohaber/lazyclaude",
  config = function()
    require("lazyclaude").setup()
  end,
}
```

## Configuration

```lua
require("lazyclaude").setup({
  -- Path or command name for the lazyclaude binary
  lazyclaude_cmd = "lazyclaude",

  -- Floating window size relative to editor (0.0 - 1.0)
  floating_window_scaling_factor = 0.9,

  -- Window transparency (0 = opaque, 100 = fully transparent)
  floating_window_winblend = 0,

  -- Border style: "none", "single", "double", "rounded", "solid", "shadow"
  floating_window_border = "rounded",

  -- Override project directory passed to lazyclaude --project-dir
  project_dir = nil,

  -- Override claude directory passed to lazyclaude --claude-dir
  claude_dir = nil,

  -- Callback when lazyclaude opens
  on_open = nil, -- fun(term: {buf: number, win: number})

  -- Callback when lazyclaude exits
  on_exit = nil, -- fun(code: number)
})
```

## Commands

| Command                     | Description                                  |
| --------------------------- | -------------------------------------------- |
| `:LazyClaude`               | Open lazyclaude in a floating window         |
| `:LazyClaudeCurrentProject` | Open scoped to the current file's git project |
| `:LazyClaudeToggle`         | Toggle lazyclaude open/closed                |
| `:LazyClaudeClose`          | Close the lazyclaude window                  |

## Keybindings

The plugin does not set any keybindings by default. Suggested mapping:

```lua
vim.keymap.set("n", "<leader>lc", "<cmd>LazyClaude<cr>", { desc = "LazyClaude" })
```

## License

Same license as [lazyclaude](https://github.com/idohaber/lazyclaude).
