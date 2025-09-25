# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a **modular Neovim configuration** based on kickstart.nvim, evolved from a single-file setup into a well-organized, multi-language development environment. The configuration provides comprehensive LSP support, intelligent formatting, and modern development tools for Rust, JavaScript/TypeScript, Python, Lua, JSON, and other languages.

## Architecture

### Core Structure
- **`init.lua`** - Entry point that loads core modules and initializes Lazy.nvim plugin manager
- **`lua/core/`** - Foundation configuration (options, keymaps, autocommands)
- **`lua/plugins/`** - Modular plugin configurations, auto-loaded by Lazy.nvim
- **`lua/custom/`** - User-specific customizations (preserved from kickstart structure)
- **`lua/kickstart/`** - Legacy kickstart plugin examples (kept for reference)

### Plugin Organization
Each plugin category has its own file in `lua/plugins/`:

- **`lsp.lua`** - Language Server Protocol configuration with 8 language servers
- **`completion.lua`** - Blink.cmp autocompletion with custom Tab/Enter keymaps
- **`formatting.lua`** - Conform.nvim with multi-language formatting support
- **`telescope.lua`** - Fuzzy finder with custom keymaps for search operations
- **`treesitter.lua`** - Syntax highlighting and parsing
- **`ui.lua`** - Appearance (themes, which-key)
- **`git.lua`** - Git integration via Gitsigns
- **`editor.lua`** - Editor enhancements (todo-comments, guess-indent)
- **`mini.lua`** - Mini.nvim modules (files, pick, move, starter, bracketed, indentscope, surround)

## Language Support

### Configured Language Servers
- **`lua_ls`** - Lua with enhanced completion
- **`rust_analyzer`** - Rust with Cargo integration, Clippy linting, inlay hints
- **`ts_ls`** - TypeScript/JavaScript with workspace detection
- **`pylsp`** - Python with linting, type checking, auto-imports
- **`jsonls`** - JSON with schema validation via schemastore
- **`bashls`** - Shell scripting (Bash, Zsh)
- **`tailwindcss`** - Tailwind CSS with class completion
- **`eslint`** - JavaScript/TypeScript linting as LSP

### Formatting Configuration
Uses Conform.nvim with language-specific formatters:
- **JS/TS/HTML/CSS/JSON/YAML/Markdown**: `prettierd` → `prettier` (fallback chain)
- **Lua**: `stylua`
- **Python**: LSP formatting via `pylsp`
- **Rust**: LSP formatting via `rust_analyzer`
- **Shell**: `shfmt` (configurable)

### Tool Management
All language tools are managed through Mason.nvim with automatic installation via `ensure_installed` lists in `lua/plugins/lsp.lua`.

## Key Customizations

### Completion (Blink.cmp)
Custom keymaps configured for intuitive completion:
- **Tab**: Navigate to next completion item
- **Shift+Tab**: Navigate to previous completion item
- **Enter**: Accept completion
- **Ctrl+Space**: Show/hide completion menu
- Intelligent fallback behavior when no completion menu is active

### File Management
Mini.files integration provides a modern file explorer experience, replacing traditional netrw.

### Search and Navigation
Telescope configured with comprehensive search capabilities:
- `<leader>sf` - Search files
- `<leader>sg` - Live grep
- `<leader>sh` - Help tags
- `<leader>sw` - Search current word
- `<leader>sr` - Resume last search

## Development Commands

### Plugin Management
```vim
:Lazy                 " View plugin status
:Lazy update         " Update all plugins
:Lazy clean          " Remove unused plugins
:Lazy profile        " View startup performance
```

### LSP Operations
```vim
:Mason               " View/install language servers and tools
:LspInfo            " View active language servers
:LspRestart         " Restart LSP servers
```

### Formatting
```vim
<leader>f           " Format current buffer
:ConformInfo        " View available formatters
```

### Health Checks
```vim
:checkhealth        " General health check
:checkhealth lazy   " Lazy.nvim specific check
:checkhealth lsp    " LSP configuration check
```

## Configuration Patterns

### Adding New Plugins
Create new files in `lua/plugins/` - they are automatically loaded:
```lua
-- lua/plugins/new-plugin.lua
return {
  'author/plugin-name',
  opts = {
    -- plugin options
  },
}
```

### Adding Language Servers
Add to the `servers` table in `lua/plugins/lsp.lua`:
```lua
new_server = {
  settings = {
    -- server-specific settings
  },
},
```

### Adding Formatters
Add to `formatters_by_ft` in `lua/plugins/formatting.lua`:
```lua
filetype = { 'formatter1', 'formatter2', stop_after_first = true },
```

### Keymaps
Core keymaps are in `lua/core/keymaps.lua`. Plugin-specific keymaps are defined within their respective plugin configurations.

## Important Notes

- This configuration targets the latest stable Neovim versions
- Nerd Font support is enabled via `vim.g.have_nerd_font = true`
- The configuration uses Lazy.nvim's import system for automatic plugin loading
- Mason tools are automatically installed based on `ensure_installed` lists
- All formatters use fallback chains for reliability
- LSP servers include comprehensive language-specific settings optimized for development