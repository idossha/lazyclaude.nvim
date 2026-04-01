# VHS tape for recording lazyclaude.nvim demo GIF
# Install VHS: brew install charmbracelet/tap/vhs
#
# Before recording, run:
#   ./demo/setup.sh
#   vhs demo/demo.tape

Output demo/lazyclaude-nvim-demo.gif
Set FontSize 14
Set Width 1400
Set Height 800
Set Theme "Catppuccin Mocha"
Set TypingSpeed 78ms
Set Padding 10

# Open Neovim with the README
Hide
Type "nvim --clean -u demo/init.lua README.md"
Enter
Sleep 2s
Show

# Show we're in Neovim editing the README
Sleep 1.3s

# Open lazyclaude with the command
Type ":LazyClaude"
Enter
Sleep 2.6s

# Panel 1: Projects — already selected
Sleep 1.3s

# Panel 2: Config — show CLAUDE.md files and rules
Type "2"
Sleep 1.95s
Type "l"
Sleep 0.65s
Type "j"
Sleep 0.65s
Type "j"
Sleep 0.65s
Type "j"
Sleep 1.3s

# Panel 3: Memory — show memory files
Type "h"
Sleep 0.39s
Type "3"
Sleep 1.95s
Type "l"
Sleep 0.65s
Type "j"
Sleep 0.65s
Type "j"
Sleep 1.3s

# Demo editor integration: press 'e' to open a memory file in nvim
Type "e"
Sleep 2s

# We're now in nvim editing the memory file — show it briefly
Sleep 1.95s

# Quit nvim back to lazyclaude
Type ":q"
Enter
Sleep 1.95s

# Panel 5: Agents
Type "h"
Sleep 0.39s
Type "5"
Sleep 1.95s
Type "l"
Sleep 0.65s
Type "j"
Sleep 0.65s
Type "j"
Sleep 1.3s

# Panel 6: MCP — show servers
Type "h"
Sleep 0.39s
Type "6"
Sleep 1.95s
Type "l"
Sleep 0.65s
Type "j"
Sleep 0.65s
Type "j"
Sleep 1.3s

# Panel 7: Settings
Type "h"
Sleep 0.39s
Type "7"
Sleep 1.95s
Type "l"
Sleep 0.65s
Type "j"
Sleep 0.39s
Type "j"
Sleep 0.39s
Type "j"
Sleep 0.39s
Type "j"
Sleep 0.39s
Type "j"
Sleep 1.3s

# Panel 9: Stats — show heatmap
Type "h"
Sleep 0.39s
Type "9"
Sleep 3.9s

# Show fuzzy filter
Type "/"
Sleep 0.65s
Type "brave"
Sleep 1.3s
Escape
Sleep 0.65s

# Quit lazyclaude (back to Neovim)
Type "q"
Sleep 1.3s

# Show we're back in Neovim with the README
Sleep 1.3s

# Quit Neovim
Type ":q"
Enter
Sleep 0.65s
