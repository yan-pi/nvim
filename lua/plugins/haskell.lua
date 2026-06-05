-- Haskell language support with HLS and development tools
-- Provides comprehensive Haskell development features including:
-- - LSP completion, diagnostics, and code actions via haskell-language-server
-- - Debugging support via haskell-debug-adapter

return {
  -- Configure haskell-language-server (hls)
  {
    'neovim/nvim-lspconfig',
    opts = function(_, opts)
      opts.servers = opts.servers or {}

      opts.servers.hls = {
        filetypes = { 'haskell', 'lhaskell', 'cabal' },
        settings = {
          haskell = {
            formattingProvider = 'fourmolu',
            checkProject = true,
          },
        },
      }
    end,
    init = function()
      -- Auto-enable hls for haskell files (excluded from mason-lspconfig automatic_enable)
      vim.api.nvim_create_autocmd('FileType', {
        group = vim.api.nvim_create_augroup('haskell-lsp-enable', { clear = true }),
        pattern = { 'haskell', 'lhaskell', 'cabal' },
        callback = function(args)
          vim.lsp.enable('hls', { bufnr = args.buf })
        end,
        desc = 'Enable hls LSP for haskell files',
      })
    end,
  },

  -- Haskell debugging with haskell-debug-adapter
  {
    'mfussenegger/nvim-dap',
    ft = 'haskell',
    config = function()
      local dap = require('dap')
      dap.adapters.haskell = {
        type = 'executable',
        command = 'haskell-debug-adapter',
        args = { '--hackage-version=0.0.33.0' },
      }
      dap.configurations.haskell = {
        {
          type = 'haskell',
          request = 'launch',
          name = 'Debug',
          workspace = '${workspaceFolder}',
          startup = '${file}',
          stopOnEntry = true,
          logFile = vim.fn.stdpath('data') .. '/haskell-dap.log',
          logLevel = 'WARNING',
          ghciEnv = vim.empty_dict(),
          ghciPrompt = 'λ: ',
          ghciInitialPrompt = 'λ: ',
          ghciCmd = 'cabal repl --with-compiler=gdc --repl-no-load --builddir=' .. vim.fn.stdpath('data') .. '/haskell-dap-dist',
        },
      }
    end,
  },

  -- Global K fallback: LSP hover if available, else man
  {
    'neovim/nvim-lspconfig',
    init = function()
      vim.keymap.set('n', 'K', function()
        if vim.lsp.buf_is_attached(0) or not vim.tbl_isempty(vim.lsp.get_clients({ bufnr = 0 })) then
          vim.lsp.buf.hover()
        else
          vim.cmd('Man ' .. vim.fn.expand('<cword>'))
        end
      end, { desc = 'LSP Hover or Man', silent = true })
    end,
  },

  -- Ensure Haskell non-LSP tools are installed via Mason.
  -- hls is auto-installed by mason-lspconfig (derived from opts.servers).
  {
    'WhoIsSethDaniel/mason-tool-installer.nvim',
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, {
        -- 'haskell-language-server', -- DISABLED: requires ghcup, using nix instead
        'fourmolu', -- Haskell formatter (used by conform.nvim)
        'haskell-debug-adapter', -- Haskell debugger adapter for DAP
      })
    end,
  },
}
