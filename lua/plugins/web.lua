-- Web language support (JavaScript, TypeScript, HTML, CSS, Tailwind)
--
-- Stack:
--   * ts_ls (LSP)        -> TypeScript/JavaScript language server
--   * eslint (LSP)       -> linting (format on save only)
--   * tailwindcss (LSP)  -> Tailwind CSS class completion
--   * vscode-js-debug    -> DAP for Node.js
--   * prettier/biome     -> formatter (project-aware)
--   * treesitter         -> syntax highlighting
--   * neotest-jest/vitest -> testing
--   * neogen             -> doc generation (jsdoc/tsdoc)
--
-- Nix installs: nodejs
-- Mason installs: js-debug-adapter

return {
  -- LSP: ts_ls, eslint, tailwindcss
  {
    'neovim/nvim-lspconfig',
    opts = function(_, opts)
      opts.servers = opts.servers or {}

      -- TypeScript/JavaScript language server
      opts.servers.ts_ls = {
        settings = {
          typescript = {
            inlayHints = {
              includeInlayParameterNameHints = 'literal',
              includeInlayParameterNameHintsWhenArgumentMatchesName = false,
              includeInlayFunctionParameterTypeHints = true,
              includeInlayVariableTypeHints = false,
              includeInlayPropertyDeclarationTypeHints = true,
              includeInlayFunctionLikeReturnTypeHints = true,
              includeInlayEnumMemberTypeHints = true,
            },
          },
          javascript = {
            inlayHints = {
              includeInlayParameterNameHints = 'all',
              includeInlayParameterNameHintsWhenArgumentMatchesName = false,
              includeInlayFunctionParameterTypeHints = true,
              includeInlayVariableTypeHints = true,
              includeInlayPropertyDeclarationTypeHints = true,
              includeInlayFunctionLikeReturnTypeHints = true,
              includeInlayEnumMemberTypeHints = true,
            },
          },
        },
      }

      -- ESLint: linting only (formatting owned by conform.nvim)
      opts.servers.eslint = {
        settings = {
          codeActionOnSave = {
            enable = true,
            mode = 'all',
          },
          format = false,
          nodePath = '',
          onIgnoredFiles = 'off',
          packageManager = 'npm',
          problems = {
            shortenToSingleLine = false,
          },
          quiet = false,
          rulesCustomizations = {},
          run = 'onSave',
          useESLintClass = false,
          validate = 'on',
          workingDirectory = { mode = 'location' },
        },
      }

      -- Tailwind CSS
      opts.servers.tailwindcss = {
        filetypes = {
          'css', 'scss', 'sass', 'html',
          'javascript', 'javascriptreact',
          'typescript', 'typescriptreact',
          'vue', 'svelte',
        },
        settings = {
          tailwindCSS = {
            classAttributes = { 'class', 'className', 'class:list', 'classList', 'ngClass' },
            lint = {
              cssConflict = 'warning',
              invalidApply = 'error',
              invalidConfigPath = 'error',
              invalidTailwindDirective = 'error',
              recommendedVariantOrder = 'warning',
            },
            validate = true,
          },
        },
      }
    end,
  },

  -- DAP: vscode-js-debug for Node.js
  {
    'mfussenegger/nvim-dap',
    ft = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact' },
    config = function()
      local dap = require 'dap'

      -- Only configure if js-debug-adapter is installed
      local mason_registry = require 'mason-registry'
      if not mason_registry.is_installed 'js-debug-adapter' then
        vim.notify('js-debug-adapter not installed. Run :MasonInstall js-debug-adapter', vim.log.levels.WARN)
        return
      end

      local mason_path = vim.fn.stdpath 'data' .. '/mason/packages'
      local js_debug_path = mason_path .. '/js-debug-adapter/js-debug/src/dapDebugServer.js'

      dap.adapters['pwa-node'] = {
        type = 'server',
        host = 'localhost',
        port = '${port}',
        executable = {
          command = 'node',
          args = { js_debug_path, '${port}' },
        },
      }

      local js_configs = {
        {
          type = 'pwa-node',
          request = 'launch',
          name = 'Launch Current File (Node)',
          program = '${file}',
          cwd = '${workspaceFolder}',
          sourceMaps = true,
          protocol = 'inspector',
          console = 'integratedTerminal',
        },
        {
          type = 'pwa-node',
          request = 'launch',
          name = 'Launch npm script',
          runtimeExecutable = 'npm',
          runtimeArgs = function()
            local script = vim.fn.input 'npm script: '
            return { 'run', script }
          end,
          cwd = '${workspaceFolder}',
          sourceMaps = true,
          protocol = 'inspector',
          console = 'integratedTerminal',
        },
        {
          type = 'pwa-node',
          request = 'launch',
          name = 'Debug Jest Tests',
          runtimeExecutable = 'node',
          runtimeArgs = {
            './node_modules/.bin/jest',
            '--runInBand',
            '--no-coverage',
            '${file}',
          },
          rootPath = '${workspaceFolder}',
          cwd = '${workspaceFolder}',
          console = 'integratedTerminal',
          internalConsoleOptions = 'neverOpen',
          sourceMaps = true,
        },
        {
          type = 'pwa-node',
          request = 'attach',
          name = 'Attach to Process',
          processId = require('dap.utils').pick_process,
          cwd = '${workspaceFolder}',
          sourceMaps = true,
          protocol = 'inspector',
        },
        {
          type = 'pwa-node',
          request = 'launch',
          name = 'Debug with --inspect',
          program = '${file}',
          cwd = '${workspaceFolder}',
          runtimeArgs = { '--inspect' },
          sourceMaps = true,
          protocol = 'inspector',
          console = 'integratedTerminal',
        },
      }

      dap.configurations.javascript = js_configs
      dap.configurations.typescript = js_configs
      dap.configurations.javascriptreact = js_configs
      dap.configurations.typescriptreact = js_configs
    end,
  },

  -- Formatter: project-aware (biome → prettier)
  {
    'stevearc/conform.nvim',
    opts = function(_, opts)
      opts.formatters_by_ft = opts.formatters_by_ft or {}
      local detect = require('core.formatting-utils').detect_formatter

      local web_fmt = function(bufnr)
        return detect(bufnr, {
          { files = { 'biome.json', 'biome.jsonc' }, formatters = { 'biome' } },
          {
            files = { '.prettierrc', '.prettierrc.json', '.prettierrc.js', '.prettierrc.yml', 'prettier.config.js', 'prettier.config.cjs' },
            formatters = { 'prettierd', 'prettier', stop_after_first = true },
          },
        }, {
          default = { 'prettierd', 'prettier', stop_after_first = true },
        })
      end

      opts.formatters_by_ft.javascript = web_fmt
      opts.formatters_by_ft.javascriptreact = web_fmt
      opts.formatters_by_ft.typescript = web_fmt
      opts.formatters_by_ft.typescriptreact = web_fmt
      opts.formatters_by_ft.html = web_fmt
      opts.formatters_by_ft.css = web_fmt
      opts.formatters_by_ft.scss = web_fmt
    end,
  },

  -- Docs: neogen with jsdoc/tsdoc
  {
    'danymat/neogen',
    opts = function(_, opts)
      opts.languages = opts.languages or {}
      opts.languages.typescript = { template = { annotation_convention = 'tsdoc' } }
      opts.languages.typescriptreact = { template = { annotation_convention = 'tsdoc' } }
      opts.languages.javascript = { template = { annotation_convention = 'jsdoc' } }
    end,
  },

  -- Treesitter: parsers for web languages
  {
    'nvim-treesitter/nvim-treesitter',
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, {
        'javascript',
        'typescript',
        'tsx',
        'html',
        'css',
        'scss',
      })
    end,
  },
}
