# Neovim Kali Minimal

A reduced branch of this Neovim configuration for a Kali Linux VM. It keeps the
navigation and visual habits of the main configuration while focusing on reading,
searching, and making small edits in `.txt` and Bash files.

## Included

- `lazy.nvim` for plugin management.
- `mini.files` and `mini.statusline` for file navigation and status.
- `snacks.nvim` picker for files, grep, buffers, recent files, help, and man pages.
- `which-key.nvim` for the retained leader-key hints.
- `bufferline.nvim` with tab-scoped buffer navigation.
- `base16-nvim` using `base16-gruvbox-material-dark-hard`.
- `toggleterm.nvim` for the existing horizontal, vertical, floating, and terminal-selection workflow. It is intentionally included and lazy-loaded only when a terminal command or mapping is used.
- Neovim's built-in filetype detection and Bash syntax highlighting.

LSP, completion, AI, debugging, testing, format-on-save, Treesitter, image
viewing, Obsidian, and language-specific stacks are intentionally not loaded.
The old plugin files remain in this checkout for comparison, but `init.lua`
explicitly loads only the five reduced plugin modules. ToggleTerm is the one
workflow exception: it is included for your existing terminal binds, but remains
lazy-loaded until you invoke it.

## Kali prerequisites

```sh
sudo apt update
sudo apt install neovim git ripgrep
```

`ripgrep` powers Snacks file and grep pickers. A Nerd Font, language server,
formatter, Node.js, Python, or Nix setup is not required.

On OrbStack Linux machines, the profile uses the provided `pbcopy`/`pbpaste`
wrappers when both are available. Because `unnamedplus` is enabled, ordinary
`y` yanks go to the macOS host clipboard; use `"+y` when you want to make the
system clipboard explicit. On other Linux environments, Neovim keeps its
normal clipboard-provider auto-detection and falls back to the internal
register when no provider is installed.

## Install or run this branch

The branch is intended to live at `~/.config/nvim-kali` in the VM. From the
repository checkout:

```sh
git worktree add -b kali-minimal ~/.config/nvim-kali main
cd ~/.config/nvim-kali
NVIM_APPNAME=nvim-kali nvim
```

On first startup Lazy.nvim installs the small plugin set. The lockfile is
machine-local and ignored by Git; run `:Lazy sync` when updating plugins.

To test the configuration without affecting another Neovim profile:

```sh
NVIM_APPNAME=nvim-kali-test ./tests/kali-minimal.sh
```

## Main shortcuts

- `<leader>e`: explorer at the current file; `<leader>E`: explorer at cwd.
- `<leader><space>` / `<leader>ff`: find files.
- `<leader>/` / `<leader>sg`: grep; `<leader>sw`: search word under cursor.
- `<leader>,`: buffers; `<leader>fr`: recent files.
- `<Tab>` / `<S-Tab>`: next/previous buffer in the current tab.
- `<leader>1` through `<leader>9`: select a buffer in the current tab.
- `<leader>ty`, `<leader>tn`, `<leader>tp`, `<leader>tc`: tab operations.
- `<leader>th`, `<leader>tv`, `<leader>ti`: toggle horizontal, vertical, or floating terminal.
- `<leader>ta`, `<leader>ts`: toggle all terminals or select a terminal.
- In terminal mode, `<Esc><Esc>` returns to Normal mode, `<C-q>` closes the terminal, and `<C-h/j/k/l>` moves between splits.
- `<C-h>`, `<C-j>`, `<C-k>`, `<C-l>`: move between splits.

See `:WhichKey` for the complete retained map.
