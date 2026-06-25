-- Python language support
--
-- Stack:
--   * ruff (LSP)         -> linting, formatting, import organization
--   * basedpyright (LSP) -> type checking, hover, completion
--   * debugpy            -> debugging via DAP
--   * venv-selector      -> virtual environment management
--   * neotest-python     -> pytest integration
--   * neogen             -> docstring generation (google_docstrings)
--   * treesitter         -> syntax highlighting
--
-- Nix installs: python3, ruff, basedpyright, debugpy
-- Mason installs: debugpy (if not in Nix)

return {
  -- LSP: ruff (linting, formatting, imports) + basedpyright (type checking)
  {
    'neovim/nvim-lspconfig',
    opts = function(_, opts)
      opts.servers = opts.servers or {}

      -- Ruff: Lightning-fast linter/formatter written in Rust
      -- Note: Using unified 'ruff' LSP server (ruff >= 0.4.0)
      --       The old 'ruff-lsp' package is deprecated
      opts.servers.ruff = {
        on_attach = function(client, bufnr)
          -- Disable hover in favor of Basedpyright
          client.server_capabilities.hoverProvider = false
        end,
        init_options = {
          settings = {
            args = {},
          },
        },
      }

      -- Basedpyright: Community fork of Pyright with better defaults
      opts.servers.basedpyright = {
        settings = {
          basedpyright = {
            analysis = {
              autoSearchPaths = true,
              diagnosticMode = 'workspace',
              useLibraryCodeForTypes = true,
              typeCheckingMode = 'basic', -- off, basic, standard, strict
            },
          },
        },
      }
    end,
  },

  -- Formatter: ruff via conform.nvim
  {
    'stevearc/conform.nvim',
    opts = function(_, opts)
      opts.formatters_by_ft = opts.formatters_by_ft or {}
      opts.formatters_by_ft.python = { 'ruff_format', 'ruff_organize_imports' }
    end,
  },

  -- Venv: venv-selector for virtual environment management
  {
    'linux-cultist/venv-selector.nvim',
    dependencies = {
      'neovim/nvim-lspconfig',
      'mfussenegger/nvim-dap-python',
    },
    branch = 'regexp',
    ft = 'python',
    opts = {
      -- Use Snacks picker instead of Telescope
      options = {
        picker = 'snacks',
      },

      -- Auto select single venv if found
      auto_refresh = true,
      search_venv_managers = true,
      search_workspace = true,

      -- Search options
      search = true,
      dap_enabled = true,

      -- Paths to search for virtual environments
      path = {
        '~/.virtualenvs',
        '~/.pyenv/versions',
        './venv',
        './.venv',
        './env',
        './.env',
      },

      -- Name patterns for virtual environments
      name = {
        'venv',
        '.venv',
        'env',
        '.env',
        'virtualenv',
      },

      -- Parent directory patterns for workspace venvs
      parents = 0,

      -- Additional poetry/pipenv support
      poetry_path = vim.fn.expand '~/.poetry/',
      pipenv_path = vim.fn.expand '~/.local/share/virtualenvs/',
      pyenv_path = vim.fn.expand '~/.pyenv/versions/',
    },
    keys = {
      {
        '<leader>vs',
        '<cmd>VenvSelect<cr>',
        desc = 'Select Python Virtual Environment',
        ft = 'python',
      },
      {
        '<leader>vc',
        '<cmd>VenvSelectCached<cr>',
        desc = 'Select Cached Python Venv',
        ft = 'python',
      },
      {
        '<leader>vd',
        function()
          require('venv-selector').deactivate()
        end,
        desc = 'Deactivate Python Venv',
        ft = 'python',
      },
      {
        '<leader>vi',
        function()
          local venv = require('venv-selector').get_active_venv()
          if venv then
            print('Active venv: ' .. venv)
          else
            print('No active virtual environment')
          end
        end,
        desc = 'Show Active Python Venv',
        ft = 'python',
      },
    },
  },

  -- Docs: neogen with google_docstrings
  {
    'danymat/neogen',
    opts = function(_, opts)
      opts.languages = opts.languages or {}
      opts.languages.python = { template = { annotation_convention = 'google_docstrings' } }
    end,
  },

  -- Treesitter: parser python
  {
    'nvim-treesitter/nvim-treesitter',
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { 'python' })
    end,
  },
}
