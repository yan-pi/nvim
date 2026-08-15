-- C/C++ language support
--
-- Stack:
--   * clangd (LSP)       -> completion, diagnostics, go-to-definition
--   * clang-format       -> formatting via conform.nvim
--   * codelldb           -> debugging via DAP
--   * treesitter         -> syntax highlighting (c is core; cpp added here)
--
-- Nix installs: clangd, clang-format, and a codelldb PATH wrapper

return {
  -- LSP: clangd for C/C++
  {
    'neovim/nvim-lspconfig',
    opts = function(_, opts)
      opts.servers = opts.servers or {}

      opts.servers.clangd = {
        cmd = {
          'clangd',
          '--background-index',
          '--clang-tidy',
          '--header-insertion=iwyu',
          '--completion-style=bundled',
          '--pch-storage=memory',
          '--cross-file-rename',
          '--fallback-style=llvm',
        },
        root_markers = { '.clangd', 'compile_commands.json', '.git' },
        filetypes = { 'c', 'cpp', 'objc', 'objcpp', 'cuda', 'proto' },
        capabilities = {
          -- clangd warns if offsetEncoding is not utf-16; nvim-lspconfig
          -- normally sets this, but we make it explicit here.
          offsetEncoding = { 'utf-16' },
        },
        settings = {
          clangd = {
            -- Inlay hints are available in clangd 14+; enable useful ones.
            InlayHints = {
              Enabled = true,
              ParameterNames = true,
              DeducedTypes = true,
            },
          },
        },
      }
    end,
  },

  -- Formatter: clang-format via conform.nvim
  {
    'stevearc/conform.nvim',
    opts = function(_, opts)
      opts.formatters_by_ft = opts.formatters_by_ft or {}
      opts.formatters_by_ft.c = { 'clang_format' }
      opts.formatters_by_ft.cpp = { 'clang_format' }
      opts.formatters_by_ft.objc = { 'clang_format' }
      opts.formatters_by_ft.objcpp = { 'clang_format' }
      opts.formatters_by_ft.cuda = { 'clang_format' }
      opts.formatters_by_ft.proto = { 'clang_format' }
    end,
  },

  -- Treesitter: parser for C++
  {
    'nvim-treesitter/nvim-treesitter',
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { 'cpp' })
    end,
  },
}
