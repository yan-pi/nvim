-- C/C++ language support
--
-- Stack:
--   * clangd (LSP)       -> completion, diagnostics, go-to-definition
--   * clang-format       -> formatting via conform.nvim
--   * codelldb           -> debugging via DAP
--   * treesitter         -> syntax highlighting (c is core; cpp added here)
--
-- Nix installs: clangd, clang-format, cppman, and a codelldb PATH wrapper

local function open_cppman()
  local query = vim.fn.expand '<cword>'
  if query == '' then
    vim.notify('No C++ symbol under cursor', vim.log.levels.WARN)
    return
  end

  if vim.fn.executable 'cppman' ~= 1 then
    vim.notify('cppman is not on PATH; activate the Nix configuration first', vim.log.levels.ERROR)
    return
  end

  vim.cmd 'botright 12new'
  vim.fn.termopen { 'cppman', '-p', 'less', '-f', query }
  vim.cmd 'startinsert'
end

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
          '--fallback-style=llvm',
        },
        root_markers = { '.clangd', 'compile_commands.json', '.git' },
        filetypes = { 'c', 'cpp', 'objc', 'objcpp', 'cuda', 'proto' },
        on_attach = function(_, bufnr)
          -- clangd 21 supports standard LSP inlay hints; enable Neovim's renderer.
          vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })

          vim.keymap.set('n', '<leader>ch', open_cppman, {
            buffer = bufnr,
            desc = 'C/C++: cppman help for symbol under cursor',
          })
        end,
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
