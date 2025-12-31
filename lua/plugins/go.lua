-- Go language support with gopls LSP and development tools
-- Provides comprehensive Go development features including:
-- - LSP completion, diagnostics, and code actions
-- - Debugging support via Delve (go-debug-adapter)

return {
  -- Configure gopls LSP server
  {
    'neovim/nvim-lspconfig',
    opts = function(_, opts)
      -- Ensure servers table exists
      opts.servers = opts.servers or {}

      -- Add gopls with comprehensive configuration
      opts.servers.gopls = {
        settings = {
          gopls = {
            -- Use gofumpt for stricter formatting
            gofumpt = true,

            -- Enable code lenses for various actions
            codelenses = {
              gc_details = false, -- Don't show GC optimization details
              generate = true, -- Show "go generate" commands
              regenerate_cgo = true, -- Show cgo regeneration
              run_govulncheck = true, -- Show vulnerability checks
              test = true, -- Show test/benchmark running
              tidy = true, -- Show "go mod tidy" suggestions
              upgrade_dependency = true, -- Show dependency upgrades
              vendor = true, -- Show "go mod vendor" commands
            },

            -- Enable inlay hints for better code understanding
            hints = {
              assignVariableTypes = true, -- Show types for := assignments
              compositeLiteralFields = true, -- Show struct field names
              compositeLiteralTypes = true, -- Show composite literal types
              constantValues = true, -- Show constant values
              functionTypeParameters = true, -- Show function type parameters
              parameterNames = true, -- Show parameter names in calls
              rangeVariableTypes = true, -- Show range variable types
            },

            -- Enable static analysis checks
            analyses = {
              fieldalignment = true, -- Detect inefficient struct field order
              nilness = true, -- Detect nil pointer dereferences
              unusedparams = true, -- Detect unused function parameters
              unusedwrite = true, -- Detect unused variable writes
              useany = true, -- Suggest using 'any' instead of 'interface{}'
            },

            -- General settings
            usePlaceholders = true, -- Use placeholders in completions
            completeUnimported = true, -- Suggest completions from unimported packages
            staticcheck = true, -- Enable staticcheck integration
            directoryFilters = { -- Exclude these directories
              '-.git',
              '-.vscode',
              '-.idea',
              '-.vscode-test',
              '-node_modules',
            },
            semanticTokens = true, -- Enable semantic highlighting
          },
        },
      }
    end,
  },

  -- Go debugging with Delve (nvim-dap-go simplifies DAP setup)
  {
    'leoluz/nvim-dap-go',
    ft = 'go',
    dependencies = { 'mfussenegger/nvim-dap' },
    config = function()
      require('dap-go').setup {
        -- Uses go-debug-adapter installed via Mason
        -- Automatically configures Delve debug adapter

        dap_configurations = {
          {
            type = 'go',
            name = 'Debug (from nearest)',
            request = 'launch',
            program = '${file}',
          },
          {
            type = 'go',
            name = 'Debug Package',
            request = 'launch',
            program = '${fileDirname}',
          },
          {
            type = 'go',
            name = 'Attach (Pick Process)',
            mode = 'local',
            request = 'attach',
            processId = require('dap.utils').pick_process,
          },
          {
            type = 'go',
            name = 'Debug Test (go test)',
            request = 'launch',
            mode = 'test',
            program = '${file}',
          },
          {
            type = 'go',
            name = 'Debug Test (go test -run)',
            request = 'launch',
            mode = 'test',
            program = '${file}',
            args = function()
              local test_name = vim.fn.input 'Test name (regexp): '
              return { '-test.run', test_name }
            end,
          },
        },

        -- Delve CLI configuration
        delve = {
          -- Path to Delve (leave nil to use go-debug-adapter from Mason)
          path = nil,
          -- Delve initialization parameters
          initialize_timeout_sec = 20,
          port = '${port}',
          args = {},
          build_flags = '',
        },
      }
    end,
  },

  -- Ensure Go tools are installed via Mason
  {
    'WhoIsSethDaniel/mason-tool-installer.nvim',
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, {
        -- Go LSP server
        'gopls',

        -- Go debugging
        'go-debug-adapter', -- Delve debugger adapter for DAP
      })
    end,
  },
}
