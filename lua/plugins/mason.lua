-- Mason tool installer configuration
-- Centralized list of all non-LSP tools (formatters, linters, DAP adapters)
-- LSP servers are managed by mason-lspconfig in lsp.lua

return {
  {
    'WhoIsSethDaniel/mason-tool-installer.nvim',
    dependencies = { 'mason-org/mason.nvim' },
    opts = {
      ensure_installed = {
        -- Formatters
        'stylua', -- Lua
        'prettier', -- JS/TS/HTML/CSS/JSON/YAML/Markdown
        'prettierd', -- Faster prettier daemon
        'biome', -- Alternative JS/TS formatter
        'shfmt', -- Shell scripts
        'fourmolu', -- Haskell
        'gofumpt', -- Go (stricter formatter)
        'clang-format', -- C/C++

        -- Debug adapters
        'debugpy', -- Python
        'go-debug-adapter', -- Go (Delve)
        'js-debug-adapter', -- JavaScript/TypeScript
        'codelldb', -- C/C++ (also used by Rust via rustaceanvim)

        -- Note: codelldb and haskell-debug-adapter are Nix-managed
        -- See dotfiles/home/packages.nix
      },
      auto_update = false,
      run_on_start = true,
      start_delay = 1000, -- Give mason-lock time to load
    },
  },
}
