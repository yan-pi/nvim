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
- **`formatting.lua`** - Conform.nvim with project-aware formatter detection (biome vs prettier)
- **`dap.lua`** - Debug Adapter Protocol with UI, virtual text, and keybindings
- **`go.lua`** - Go language server (gopls) and debugging (Delve)
- **`javascript.lua`** - Node.js debugging configuration (vscode-js-debug)
- **`rust.lua`** - Rust development with rust-analyzer and debugging
- **`testing.lua`** - Neotest integration for Go, Rust, Python, JS/TS tests
- **`snacks.lua`** - Snacks.nvim picker for all fuzzy finding (files, grep, LSP symbols, git, etc.)
- **`treesitter.lua`** - Syntax highlighting and parsing
- **`ui.lua`** - Appearance (themes, which-key)
- **`git.lua`** - Git integration via Gitsigns
- **`editor.lua`** - Editor enhancements (todo-comments, guess-indent)
- **`mini.lua`** - Mini.nvim modules (files, move, starter, bracketed, indentscope, surround)
- **`bufferline.lua`** - Tab-scoped buffer management with visual tabline

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
Uses Conform.nvim with **project-aware formatter detection**:
- **JS/TS/HTML/CSS/JSON/YAML/Markdown**: Detects `biome.json` or `.prettierrc` in project root
  - If `biome.json` found → uses `biome`
  - If `.prettierrc*` found → uses `prettierd` → `prettier` (fallback chain)
  - Otherwise → uses `prettierd` → `prettier` (default)
- **Lua**: `stylua`
- **Python**: `ruff_format` + `ruff_organize_imports`
- **Rust**: LSP formatting via `rust_analyzer`
- **Shell**: `shfmt`

**Extensibility**: The `detect_formatter()` helper in `lua/plugins/formatting.lua` makes it easy to add new project-aware formatters.

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

### Navigation & Search
All file/symbol/grep navigation uses **Snacks picker** exclusively (no Telescope):

**Files & Buffers:**
- `<leader><space>` - Smart file finder (git-aware)
- `<leader>ff` - Find files
- `<leader>fr` - Recent files
- `<leader>,` - Buffer switcher
- `<leader>bt` - Tab-scoped buffers
- `<leader>fp` - Project switcher

**Symbol Navigation:**
- `<leader>a` - Document symbols (LSP, replaces Aerial)
- `<leader>A` - Workspace symbols (LSP)
- `<leader>ss` - LSP symbols
- `<leader>sS` - LSP workspace symbols
- `gd` - Go to definition
- `gr` - Find references
- `gI` - Go to implementation
- `gy` - Go to type definition

**Search:**
- `<leader>/` - Live grep
- `<leader>sg` - Grep files
- `<leader>sw` - Search word under cursor
- `<leader>sb` - Search buffer lines
- `<leader>sB` - Grep open buffers

**Git:**
- `<leader>gb` - Git branches
- `<leader>gl` - Git log
- `<leader>gs` - Git status
- `<leader>gd` - Git diff
- `<leader>gc` - Git commits

**Vim Internals:**
- `<leader>sc` - Commands
- `<leader>sk` - Keymaps
- `<leader>sh` - Help tags
- `<leader>sm` - Man pages
- `<leader>s"` - Registers
- `<leader>s/` - Search history

### Debugging (DAP)
Full debugging support with visual interface:
- **Go**: Delve debugger via nvim-dap-go
- **JavaScript/TypeScript**: Node.js debugging via vscode-js-debug
- **Rust**: CodeLLDB via rustaceanvim
- **Python**: debugpy via nvim-dap-python

**DAP UI**: Bottom panel layout (customizable) with auto-open/close  
**Virtual Text**: Inline variable values during debugging

#### Debug Keybindings (all under `<leader>d`)
- `<leader>dc` - Continue/Start debugging
- `<leader>ds` - Step over
- `<leader>di` - Step into
- `<leader>do` - Step out
- `<leader>dx` - Terminate session
- `<leader>db` - Toggle breakpoint
- `<leader>dB` - Conditional breakpoint
- `<leader>dl` - Log point
- `<leader>du` - Toggle DAP UI
- `<leader>dr` - Toggle REPL
- `<leader>dk` - Hover/eval expression
- `<leader>dp` - Preview value

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
<leader>uf          " Toggle auto-format on save
:ConformInfo        " View available formatters
```

### Debugging
```vim
<leader>dc          " Continue/Start debugging
<leader>ds          " Step over
<leader>di          " Step into
<leader>do          " Step out
<leader>dx          " Terminate session
<leader>db          " Toggle breakpoint
<leader>du          " Toggle DAP UI
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