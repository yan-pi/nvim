-- Debug Adapter Protocol (DAP) configuration
-- Provides visual debugging interface and core DAP functionality
-- Language-specific DAP configurations are in respective files (go.lua, javascript.lua, rust.lua)

return {
  -- Core DAP plugin
  {
    'mfussenegger/nvim-dap',
    dependencies = {
      'nvim-neotest/nvim-nio', -- Async I/O (required by nvim-dap-ui)
    },
    keys = {
      -- Debug session control
      {
        '<leader>dc',
        function()
          require('dap').continue()
        end,
        desc = '[D]ebug [C]ontinue/Start',
      },
      {
        '<leader>ds',
        function()
          require('dap').step_over()
        end,
        desc = '[D]ebug [S]tep over',
      },
      {
        '<leader>di',
        function()
          require('dap').step_into()
        end,
        desc = '[D]ebug Step [I]nto',
      },
      {
        '<leader>do',
        function()
          require('dap').step_out()
        end,
        desc = '[D]ebug Step [O]ut',
      },
      {
        '<leader>dx',
        function()
          require('dap').terminate()
        end,
        desc = '[D]ebug Terminate (e[X]it)',
      },

      -- Breakpoints
      {
        '<leader>db',
        function()
          require('dap').toggle_breakpoint()
        end,
        desc = '[D]ebug Toggle [B]reakpoint',
      },
      {
        '<leader>dB',
        function()
          require('dap').set_breakpoint(vim.fn.input 'Breakpoint condition: ')
        end,
        desc = '[D]ebug Conditional [B]reakpoint',
      },
      {
        '<leader>dl',
        function()
          require('dap').set_breakpoint(nil, nil, vim.fn.input 'Log point message: ')
        end,
        desc = '[D]ebug [L]og point',
      },

      -- UI and information
      {
        '<leader>du',
        function()
          require('dapui').toggle()
        end,
        desc = '[D]ebug Toggle [U]I',
      },
      {
        '<leader>dr',
        function()
          require('dap').repl.toggle()
        end,
        desc = '[D]ebug Toggle [R]EPL',
      },
      {
        '<leader>dk',
        function()
          require('dap.ui.widgets').hover()
        end,
        desc = '[D]ebug Hover (eval)',
      },
      {
        '<leader>dp',
        function()
          require('dap.ui.widgets').preview()
        end,
        desc = '[D]ebug [P]review',
      },

      -- Stack navigation
      {
        '<leader>dj',
        function()
          require('dap').down()
        end,
        desc = '[D]ebug Stack [J] (down)',
      },
      {
        '<leader>d<Up>',
        function()
          require('dap').up()
        end,
        desc = '[D]ebug Stack Up',
      },
    },
  },

  -- DAP UI - Visual debugging interface
  {
    'rcarriga/nvim-dap-ui',
    dependencies = { 'mfussenegger/nvim-dap', 'nvim-neotest/nvim-nio' },
    config = function()
      local dap = require 'dap'
      local dapui = require 'dapui'

      -- CUSTOMIZATION GUIDE:
      --
      -- Layout Options:
      --   position: 'bottom' | 'top' | 'left' | 'right'
      --   size: number of lines (bottom/top) or columns (left/right)
      --
      -- Available Elements:
      --   'scopes' - Local variables and their values
      --   'breakpoints' - List of all breakpoints
      --   'stacks' - Call stack frames
      --   'watches' - Watch expressions
      --   'repl' - REPL console for expressions
      --   'console' - Debug output/logs
      --
      -- To change layout to sidebar instead of bottom panel:
      --   Change position = 'bottom' to position = 'right' or 'left'
      --   Adjust size to column width (e.g., size = 50)
      --
      -- To disable auto-open:
      --   Comment out dap.listeners.after.event_initialized

      dapui.setup {
        layouts = {
          {
            -- Bottom panel layout (main debugging view)
            elements = {
              { id = 'scopes', size = 0.4 }, -- Local variables (40% of panel)
              { id = 'breakpoints', size = 0.2 }, -- Breakpoints list (20%)
              { id = 'stacks', size = 0.2 }, -- Call stack (20%)
              { id = 'watches', size = 0.2 }, -- Watch expressions (20%)
            },
            size = 15, -- Height of bottom panel (lines)
            position = 'bottom',
          },
          {
            -- Right sidebar for console/REPL (optional, can be toggled with <leader>du)
            elements = {
              { id = 'repl', size = 0.5 }, -- REPL console (50% of sidebar)
              { id = 'console', size = 0.5 }, -- Debug output (50%)
            },
            size = 60, -- Width of sidebar (columns)
            position = 'right',
          },
        },
        floating = {
          border = 'rounded',
          mappings = {
            close = { 'q', '<Esc>' },
          },
        },
        controls = {
          enabled = true,
          -- Display controls in this element
          element = 'repl',
        },
        render = {
          max_type_length = nil, -- Can be integer or nil
          max_value_lines = 100, -- Can be integer or nil
        },
      }

      -- Auto-open DAP UI when debugging starts
      dap.listeners.after.event_initialized['dapui_config'] = function()
        dapui.open()
      end

      -- Auto-close DAP UI when debugging ends
      dap.listeners.before.event_terminated['dapui_config'] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited['dapui_config'] = function()
        dapui.close()
      end
    end,
  },

  -- Virtual text - Show variable values inline
  {
    'theHamsta/nvim-dap-virtual-text',
    dependencies = { 'mfussenegger/nvim-dap' },
    opts = {
      enabled = true, -- Enable by default
      enabled_commands = true, -- Create commands DapVirtualTextEnable, DapVirtualTextDisable, DapVirtualTextToggle
      highlight_changed_variables = true, -- Highlight changed values with different color
      highlight_new_as_changed = true, -- Highlight new variables as changed
      show_stop_reason = true, -- Show stop reason when stopped
      commented = false, -- Prefix virtual text with comment string
      only_first_definition = true, -- Only show virtual text at first definition
      all_references = false, -- Show virtual text on all references (not just first)
      clear_on_continue = false, -- Clear virtual text on "continue"
      
      -- Customize virtual text display
      display_callback = function(variable, buf, stackframe, node, options)
        if options.virt_text_pos == 'inline' then
          return ' = ' .. variable.value
        else
          return variable.name .. ' = ' .. variable.value
        end
      end,

      -- Position of virtual text, see :h nvim_buf_set_extmark()
      virt_text_pos = vim.fn.has 'nvim-0.10' == 1 and 'inline' or 'eol',

      -- Experimental features
      all_frames = false, -- Show virtual text for all stack frames
      virt_lines = false, -- Show virtual text on separate lines
      virt_text_win_col = nil, -- Position the virtual text at a fixed column
    },
  },

  -- Ensure debug adapters are installed
  {
    'WhoIsSethDaniel/mason-tool-installer.nvim',
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, {
        -- Debug adapters for various languages
        'codelldb', -- C/C++/Rust debugging (used in rust.lua)
        'js-debug-adapter', -- JavaScript/TypeScript debugging via vscode-js-debug
        'go-debug-adapter', -- Go debugging via Delve (also in go.lua)
      })
    end,
  },
}
