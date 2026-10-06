# AGENTS.md

## Scope

This branch is the Kali Linux minimal profile for reading, navigating, and making
small edits in text and Bash files. Keep the configuration portable and usable
without a Nerd Font, Nix, Zellij, macOS tools, or development servers.

## Loaded plugins

`init.lua` explicitly loads only these plugin modules:

- `mini.nvim`: `mini.files` and `mini.statusline` only.
- `snacks.nvim`: basic files, grep, buffers, recent files, help, and man pickers.
- `which-key.nvim`: hints for retained shortcuts.
- `bufferline.nvim`: tab-scoped buffers.
- `base16-nvim`: `base16-gruvbox-material-dark-hard`.
- `toggleterm.nvim`: the existing horizontal, vertical, floating, all-terminal,
  and terminal-selection binds. It is intentionally included for the user's
  workflow and lazy-loaded only when invoked.

Do not add LSP, completion, AI, DAP, testing, format-on-save, Treesitter,
image, Obsidian, or language-specific stacks to this branch.

## Requirements

On Kali, install the system prerequisites with:

```sh
sudo apt update
sudo apt install neovim git ripgrep
```

Neovim plugins are installed by Lazy.nvim on first startup. Development tools
are never downloaded or managed by this configuration. The generated
`lazy-lock.json` is ignored because plugin state is local to this profile.

## Validation

Run the isolated test suite from this worktree:

```sh
NVIM_APPNAME=nvim-kali-test ./tests/kali-minimal.sh
```

For a manual startup, use an app name explicitly so this profile cannot touch a
different Neovim data directory:

```sh
NVIM_APPNAME=nvim-kali nvim -u /path/to/nvim-kali/init.lua
```

Run `stylua --check init.lua lua tests` when Stylua is available. Do not run the
main profile's `nvim` without `NVIM_APPNAME` while validating this branch.
