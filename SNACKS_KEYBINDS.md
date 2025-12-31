# Snacks Picker Keybindings Reference

This document provides a comprehensive reference for all Snacks.nvim picker keybindings configured in this Neovim setup.

## Quick Access Pickers

| Keybinding | Description |
|------------|-------------|
| `<leader><space>` | Smart file finder (git-aware) |
| `<leader>,` | Buffer switcher |
| `<leader>/` | Live grep |
| `<leader>:` | Command history |

## Files & Buffers

| Keybinding | Description |
|------------|-------------|
| `<leader>ff` | Find files |
| `<leader>fg` | Find git files |
| `<leader>fr` | Recent files |
| `<leader>fc` | Find config file |
| `<leader>fp` | Project switcher |
| `<leader>fb` | Buffers |
| `<leader>bt` | Tab-scoped buffers (current tab only) |

## Git

| Keybinding | Description |
|------------|-------------|
| `<leader>gb` | Git branches |
| `<leader>gl` | Git log |
| `<leader>gL` | Git log line |
| `<leader>gs` | Git status |
| `<leader>gS` | Git stash |
| `<leader>gd` | Git diff (hunks) |
| `<leader>gf` | Git log file |
| `<leader>gB` | Git browse (open in browser) |
| `<leader>gg` | Lazygit |

## GitHub CLI Integration

| Keybinding | Description |
|------------|-------------|
| `<leader>gi` | GitHub issues (open) |
| `<leader>gI` | GitHub issues (all - includes closed) |
| `<leader>gp` | GitHub pull requests (open) |
| `<leader>gP` | GitHub pull requests (all - includes closed) |

**Requirements:** `gh` CLI installed and authenticated (`gh auth login`)

## Search & Grep

| Keybinding | Description |
|------------|-------------|
| `<leader>sg` | Grep files |
| `<leader>sw` | Search word under cursor (or visual selection) |
| `<leader>sb` | Search buffer lines |
| `<leader>sB` | Grep open buffers |
| `<leader>s/` | Search history |

## LSP Symbol Navigation

| Keybinding | Description |
|------------|-------------|
| `<leader>a` | Document symbols (replaces Aerial) |
| `<leader>A` | Workspace symbols (replaces Aerial Nav) |
| `<leader>ss` | LSP symbols |
| `<leader>sS` | LSP workspace symbols |
| `gd` | Go to definition |
| `gD` | Go to declaration |
| `gr` | Find references |
| `gI` | Go to implementation |
| `gy` | Go to type definition |

## Diagnostics

| Keybinding | Description |
|------------|-------------|
| `<leader>sd` | Diagnostics (workspace) |
| `<leader>sD` | Buffer diagnostics |

## Vim Internals

| Keybinding | Description |
|------------|-------------|
| `<leader>sc` | Command history |
| `<leader>sC` | Commands |
| `<leader>sk` | Keymaps |
| `<leader>sh` | Help pages |
| `<leader>sH` | Highlights |
| `<leader>sm` | Marks |
| `<leader>sM` | Man pages |
| `<leader>sj` | Jumps |
| `<leader>sl` | Location list |
| `<leader>sq` | Quickfix list |
| `<leader>s"` | Registers |
| `<leader>sa` | Autocmds |
| `<leader>si` | Icons |
| `<leader>sp` | Search for plugin spec (Lazy.nvim) |
| `<leader>su` | Undo history |
| `<leader>sR` | Resume last picker |

## UI & Appearance

| Keybinding | Description |
|------------|-------------|
| `<leader>uC` | Colorscheme picker |

## Other Snacks Features

### Window Management
| Keybinding | Description |
|------------|-------------|
| `<leader>z` | Toggle Zen mode |
| `<leader>Z` | Toggle Zoom |

### Scratch Buffers
| Keybinding | Description |
|------------|-------------|
| `<leader>.` | Toggle scratch buffer |
| `<leader>S` | Select scratch buffer |

### Notifications
| Keybinding | Description |
|------------|-------------|
| `<leader>n` | Notification history |
| `<leader>un` | Dismiss all notifications |

### Buffer Management
| Keybinding | Description |
|------------|-------------|
| `<leader>bd` | Delete buffer (tab-scoped) |

### File Operations
| Keybinding | Description |
|------------|-------------|
| `<leader>cR` | Rename file (LSP-aware) |

### Terminal
| Keybinding | Description |
|------------|-------------|
| `<Ctrl-/>` | Toggle terminal |
| `<Ctrl-_>` | Toggle terminal (alternate) |

### LSP Word References
| Keybinding | Description |
|------------|-------------|
| `]]` | Next reference |
| `[[` | Previous reference |

### Documentation
| Keybinding | Description |
|------------|-------------|
| `<leader>N` | Neovim news |

## Toggle Options

| Keybinding | Description |
|------------|-------------|
| `<leader>us` | Toggle spelling |
| `<leader>uw` | Toggle wrap |
| `<leader>uL` | Toggle relative numbers |
| `<leader>ud` | Toggle diagnostics |
| `<leader>ul` | Toggle line numbers |
| `<leader>uc` | Toggle conceal level |
| `<leader>uT` | Toggle treesitter |
| `<leader>ub` | Toggle dark background |
| `<leader>uh` | Toggle inlay hints |
| `<leader>ug` | Toggle indent guides |
| `<leader>uD` | Toggle dim mode |

## Image Viewer

**Enabled:** Yes (requires terminal with Kitty Graphics Protocol support - Ghostty ✅)

**Supported formats:**
- Images: PNG, JPG, GIF, WebP, BMP
- Videos: MP4, MOV (limited support)
- Documents: PDF (converted to images)

**Usage:** Simply open an image file in Neovim:
```bash
nvim screenshot.png
```

The image will be rendered inline in the buffer using the Kitty Graphics Protocol.

## Tips

### Picker Navigation (inside picker window)
- `<Ctrl-n>` / `<Down>` - Next item
- `<Ctrl-p>` / `<Up>` - Previous item
- `<Enter>` - Select item
- `<Esc>` or `<Ctrl-c>` - Close picker
- `<Ctrl-u>` - Scroll preview up
- `<Ctrl-d>` - Scroll preview down

### GitHub CLI Integration
Before using GitHub CLI pickers, ensure:
1. `gh` is installed: `brew install gh`
2. You're authenticated: `gh auth login`
3. You're in a git repository with a GitHub remote

### Smart File Finder (`<leader><space>`)
- Automatically uses `git_files()` if in a git repo
- Falls back to `files()` if not in a git repo
- Respects `.gitignore` when in git repos

### Resume Last Picker (`<leader>sR`)
Quickly reopen the last picker with the same query/filters. Useful for iterating on searches.

### Tab-Scoped Buffers (`<leader>bt`)
Shows only buffers that have been opened in the current tab. Works with the bufferline.nvim tab-scoped buffer management.

## Total Keybindings

**Pickers:** 79 keybindings  
**Other Snacks features:** 15 keybindings  
**Toggle options:** 11 keybindings  

**Grand Total:** 105 keybindings configured
