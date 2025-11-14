-- Testing with neotest
-- Run tests without leaving Neovim with instant visual feedback

return {
  {
    'nvim-neotest/neotest',
    dependencies = {
      'nvim-neotest/nvim-nio',
      'nvim-lua/plenary.nvim',
      'antoinemadec/FixCursorHold.nvim',
      'nvim-treesitter/nvim-treesitter',

      -- Language adapters
      'rouge8/neotest-rust', -- Rust test support
      'nvim-neotest/neotest-python', -- Python unittest/pytest
      'nvim-neotest/neotest-jest', -- JavaScript/TypeScript Jest
      'marilari88/neotest-vitest', -- Vitest support
    },
    keys = {
      {
        '<leader>Tt',
        function()
          require('neotest').run.run()
        end,
        desc = '[T]est Run nearest [t]est',
      },
      {
        '<leader>Tf',
        function()
          require('neotest').run.run(vim.fn.expand '%')
        end,
        desc = '[T]est Run [f]ile',
      },
      {
        '<leader>Ta',
        function()
          require('neotest').run.run(vim.fn.getcwd())
        end,
        desc = '[T]est Run [a]ll tests',
      },
      {
        '<leader>Ts',
        function()
          require('neotest').summary.toggle()
        end,
        desc = '[T]est Toggle [s]ummary',
      },
      {
        '<leader>To',
        function()
          require('neotest').output.open { enter = true, auto_close = true }
        end,
        desc = '[T]est Show [o]utput',
      },
      {
        '<leader>TO',
        function()
          require('neotest').output_panel.toggle()
        end,
        desc = '[T]est Toggle [O]utput panel',
      },
      {
        '<leader>Tp',
        function()
          require('neotest').run.stop()
        end,
        desc = '[T]est Sto[p] nearest test',
      },
      {
        '<leader>Tw',
        function()
          require('neotest').watch.toggle()
        end,
        desc = '[T]est [w]atch nearest test',
      },
      {
        '<leader>TW',
        function()
          require('neotest').watch.toggle(vim.fn.expand '%')
        end,
        desc = '[T]est [W]atch file',
      },
      {
        '<leader>Td',
        function()
          require('neotest').run.run { strategy = 'dap' }
        end,
        desc = '[T]est [d]ebug nearest test',
      },
      {
        '[t',
        function()
          require('neotest').jump.prev { status = 'failed' }
        end,
        desc = 'Jump to previous failed test',
      },
      {
        ']t',
        function()
          require('neotest').jump.next { status = 'failed' }
        end,
        desc = 'Jump to next failed test',
      },
    },
    config = function()
      require('neotest').setup {
        adapters = {
          require 'neotest-rust' {
            args = { '--no-capture' },
            dap_adapter = 'codelldb',
          },
          require 'neotest-python' {
            dap = { justMyCode = false },
            runner = 'pytest',
            python = function()
              -- Use activated virtualenv if available
              local venv = os.getenv 'VIRTUAL_ENV'
              if venv then
                return venv .. '/bin/python'
              end
              return vim.fn.exepath 'python3' or vim.fn.exepath 'python'
            end,
          },
          require 'neotest-jest' {
            jestCommand = 'npm test --',
            env = { CI = true },
            cwd = function()
              return vim.fn.getcwd()
            end,
          },
          require 'neotest-vitest',
        },
        discovery = {
          enabled = true,
          concurrent = 1,
        },
        diagnostic = {
          enabled = true,
          severity = vim.diagnostic.severity.ERROR,
        },
        floating = {
          border = 'rounded',
          max_height = 0.8,
          max_width = 0.9,
        },
        icons = {
          passed = '✓',
          running = '●',
          failed = '✗',
          skipped = '○',
          unknown = '?',
        },
        output = {
          enabled = true,
          open_on_run = false,
        },
        status = {
          enabled = true,
          signs = true,
          virtual_text = false,
        },
        strategies = {
          integrated = {
            width = 120,
            height = 40,
          },
        },
      }
    end,
  },
}
