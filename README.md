# Neovim configuration

A modular Neovim configuration used as the human editor alongside the Pi coding
harness.

## Tooling contract

- Nix/Home Manager installs language servers, formatters, linters, and debug
  adapters.
- Neovim configures those tools and consumes them from `PATH`.
- Project-local tools or an optional `direnv`/devShell environment may override
  the Nix defaults.
- Neovim never downloads development tools implicitly.
- Pi is the primary coding harness; Neovim remains the interactive editor for
  navigation, manual edits, and automatic formatting.

The complete package-to-executable matrix lives in
`~/dotfiles/TOOLING.md`.

## Structure

- `init.lua`: entry point and Lazy.nvim bootstrap.
- `lua/core/`: options, keymaps, autocmds, language toggles, and shared helpers.
- `lua/plugins/lsp.lua`: common Neovim LSP client behavior.
- `lua/plugins/<language>.lua`: language-specific LSP, formatter, DAP, testing,
  and Treesitter settings.
- `lua/plugins/formatting.lua`: Conform format-on-save policy.
- `lua/plugins/dap.lua`: common DAP UI and JavaScript adapter configuration.

## Formatting

Format-on-save is enabled by default. Project configuration wins; otherwise the
Nix-provided machine defaults are used:

- JavaScript/TypeScript/JSON/YAML/Markdown/HTML/CSS: Biome when configured,
  otherwise Prettier.
- Python: Ruff.
- Rust: rustfmt through rust-analyzer.
- Go: gofmt.
- Lua: StyLua.
- Shell: shfmt.
- C/C++: clang-format.
- Haskell: Fourmolu.
- R: Air.
- LaTeX: latexindent.

Keymaps:

- `<leader>f`: format the current buffer.
- `<leader>uf`: toggle format-on-save globally.
- `<leader>uF`: toggle format-on-save for the current buffer.
- `:ConformInfo`: inspect formatter resolution.

## LSP

Language servers are registered through Neovim 0.11's `vim.lsp.config` API and
enabled directly from `PATH`. Rust is owned by rustaceanvim; optional Haskell,
Lean, and R stacks own their specialized server lifecycles.

Useful commands:

```vim
:LspInfo
:LspRestart
:checkhealth lsp
```

## Tool installation and updates

Edit `~/dotfiles/home/packages.nix`, then build/apply the pinned Nix
configuration. Do not add editor-private installers or fallback downloads.

After changing tooling, validate:

```text
:checkhealth
:LspInfo
:ConformInfo
```

## Optional language stacks

`lua/core/lang-toggles.lua` controls the optional Lean, R, Scheme, and Haskell
stacks. Their packages remain declarative in the dotfiles when enabled.
