-- Enhanced Rust development with crates.nvim and rustaceanvim

return {
  -- Inline crate version display and management for Cargo.toml
  {
    'saecki/crates.nvim',
    event = { 'BufRead Cargo.toml' },
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts = {
      lsp = {
        enabled = true,
        on_attach = function(client, bufnr)
          -- Crates-specific keybindings for Cargo.toml files
          vim.keymap.set('n', 'K', function()
            if require('crates').popup_available() then
              require('crates').show_popup()
            else
              vim.lsp.buf.hover()
            end
          end, { desc = 'Show crate documentation', buffer = bufnr })
        end,
        actions = true,
        completion = true,
        hover = true,
      },
      completion = {
        blink = { enabled = true },
      },
    },
    config = function(_, opts)
      require('crates').setup(opts)

      -- Keymaps for crate management (only in Cargo.toml)
      vim.api.nvim_create_autocmd('BufRead', {
        pattern = 'Cargo.toml',
        callback = function()
          vim.keymap.set('n', '<leader>ct', function()
            require('crates').toggle()
          end, { desc = '[C]rates [T]oggle', buffer = true })

          vim.keymap.set('n', '<leader>cr', function()
            require('crates').reload()
          end, { desc = '[C]rates [R]eload', buffer = true })

          vim.keymap.set('n', '<leader>cu', function()
            require('crates').update_crate()
          end, { desc = '[C]rate [U]pdate', buffer = true })

          vim.keymap.set('n', '<leader>ca', function()
            require('crates').update_all_crates()
          end, { desc = '[C]rates Update [A]ll', buffer = true })

          vim.keymap.set('n', '<leader>cU', function()
            require('crates').upgrade_crate()
          end, { desc = '[C]rate [U]pgrade (breaking)', buffer = true })

          vim.keymap.set('n', '<leader>cA', function()
            require('crates').upgrade_all_crates()
          end, { desc = '[C]rates Upgrade [A]ll (breaking)', buffer = true })

          vim.keymap.set('n', '<leader>ch', function()
            require('crates').open_homepage()
          end, { desc = '[C]rate [H]omepage', buffer = true })

          vim.keymap.set('n', '<leader>cd', function()
            require('crates').open_documentation()
          end, { desc = '[C]rate [D]ocumentation', buffer = true })

          vim.keymap.set('n', '<leader>cg', function()
            require('crates').open_repository()
          end, { desc = '[C]rate [G]it repository', buffer = true })
        end,
      })
    end,
  },

  -- Enhanced rust-analyzer integration (replaces built-in LSP for Rust)
  {
    'mrcjkb/rustaceanvim',
    version = '^5',
    lazy = false, -- Load immediately for Rust files
    ft = { 'rust' },
    opts = {
      server = {
        on_attach = function(client, bufnr)
          -- Rustacean-specific keybindings
          vim.keymap.set('n', '<leader>rr', function()
            vim.cmd.RustLsp 'runnables'
          end, { desc = '[R]ust [R]unnables', buffer = bufnr })

          vim.keymap.set('n', '<leader>rd', function()
            vim.cmd.RustLsp 'debuggables'
          end, { desc = '[R]ust [D]ebuggables', buffer = bufnr })

          vim.keymap.set('n', '<leader>rt', function()
            vim.cmd.RustLsp { 'testables', bang = true }
          end, { desc = '[R]ust [T]estables', buffer = bufnr })

          vim.keymap.set('n', '<leader>re', function()
            vim.cmd.RustLsp 'expandMacro'
          end, { desc = '[R]ust [E]xpand macro', buffer = bufnr })

          vim.keymap.set('n', '<leader>rm', function()
            vim.cmd.RustLsp 'rebuildProcMacros'
          end, { desc = '[R]ust Rebuild proc [M]acros', buffer = bufnr })

          vim.keymap.set('n', '<leader>rp', function()
            vim.cmd.RustLsp 'parentModule'
          end, { desc = '[R]ust [P]arent module', buffer = bufnr })

          vim.keymap.set('n', '<leader>rc', function()
            vim.cmd.RustLsp 'openCargo'
          end, { desc = '[R]ust Open [C]argo.toml', buffer = bufnr })

          vim.keymap.set('n', '<leader>rg', function()
            vim.cmd.RustLsp 'crateGraph'
          end, { desc = '[R]ust Crate [G]raph', buffer = bufnr })

          vim.keymap.set('n', '<leader>rv', function()
            vim.cmd.RustLsp { 'view', 'hir' }
          end, { desc = '[R]ust [V]iew HIR', buffer = bufnr })

          vim.keymap.set('n', '<leader>rV', function()
            vim.cmd.RustLsp { 'view', 'mir' }
          end, { desc = '[R]ust [V]iew MIR', buffer = bufnr })

          -- Code actions
          vim.keymap.set('n', '<leader>ra', function()
            vim.cmd.RustLsp 'codeAction'
          end, { desc = '[R]ust Code [A]ction', buffer = bufnr })

          vim.keymap.set('n', '<leader>rh', function()
            vim.cmd.RustLsp { 'hover', 'actions' }
          end, { desc = '[R]ust [H]over actions', buffer = bufnr })

          vim.keymap.set('n', '<leader>rj', function()
            vim.cmd.RustLsp 'joinLines'
          end, { desc = '[R]ust [J]oin lines', buffer = bufnr })
        end,
        default_settings = {
          ['rust-analyzer'] = {
            cargo = {
              allFeatures = true,
              loadOutDirsFromCheck = true,
              buildScripts = {
                enable = true,
              },
            },
            checkOnSave = {
              command = 'clippy',
              allFeatures = true,
            },
            procMacro = {
              enable = true,
              ignored = {
                ['async-trait'] = { 'async_trait' },
                ['napi-derive'] = { 'napi' },
                ['async-recursion'] = { 'async_recursion' },
              },
            },
            inlayHints = {
              bindingModeHints = {
                enable = false,
              },
              chainingHints = {
                enable = true,
              },
              closingBraceHints = {
                enable = true,
                minLines = 25,
              },
              closureReturnTypeHints = {
                enable = 'never',
              },
              lifetimeElisionHints = {
                enable = 'never',
                useParameterNames = false,
              },
              maxLength = 25,
              parameterHints = {
                enable = true,
              },
              reborrowHints = {
                enable = 'never',
              },
              renderColons = true,
              typeHints = {
                enable = true,
                hideClosureInitialization = false,
                hideNamedConstructor = false,
              },
            },
          },
        },
      },
      -- DAP configuration
      dap = {
        adapter = {
          type = 'executable',
          command = 'codelldb',
          name = 'rt_lldb',
        },
      },
    },
    config = function(_, opts)
      vim.g.rustaceanvim = vim.tbl_deep_extend('keep', vim.g.rustaceanvim or {}, opts or {})
    end,
  },

  -- Ensure Rust tools are installed via Mason
  {
    'WhoIsSethDaniel/mason-tool-installer.nvim',
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, {
        'bacon', -- Background Rust compiler/checker for real-time feedback
        'codelldb', -- Rust debugger (also in dap.lua, but listed here for clarity)
      })
    end,
  },
}
