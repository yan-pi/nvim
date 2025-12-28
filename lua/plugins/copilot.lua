return {
  {
    'zbirenbaum/copilot.lua',
    dependencies = {
      'copilotlsp-nvim/copilot-lsp',
    },
    cmd = 'Copilot',
    event = { 'InsertEnter', 'BufReadPre' },
    config = function()
      require('copilot').setup {
        panel = {
          enabled = true,
          auto_refresh = true,
          keymap = {
            jump_prev = '[[',
            jump_next = ']]',
            accept = '<CR>',
            refresh = 'gr',
            open = '<leader>cp',
          },
          layout = {
            position = 'bottom',
            ratio = 0.4,
          },
        },
        suggestion = {
          enabled = true, -- Disabled for blink-cmp-copilot integration
          auto_trigger = true,
          hide_during_completion = true,
          debounce = 75,
          trigger_on_accept = true,
          keymap = {
            accept = '<C-y>',
            next = '<C-n>',
            prev = '<C-p>',
            dismiss = '<C-]>',
          },
        },
        nes = {
          enabled = false, -- Set to true if you want NES functionality and have copilot-lsp installed
        },
        copilot_node_command = 'node', -- Node.js version must be > 20
        server_opts_overrides = {
          settings = {
            advanced = {
              model = 'claude-4',
              temperature = 0.1,
              listCount = 10, -- completions for panel
              inlineSuggestCount = 3, -- completions for getCompletions
            },
          },
          offset_encoding = 'utf-16',
        },
        filetypes = {
          markdown = true,
          help = true,
          gitcommit = true,
          ['*'] = true,
        },
      }
      -- Hide Copilot suggestion when BlinkCmp menu is open
      vim.api.nvim_create_autocmd('User', {
        pattern = 'BlinkCmpMenuOpen',
        callback = function()
          vim.b.copilot_suggestion_hidden = true
        end,
      })
      vim.api.nvim_create_autocmd('User', {
        pattern = 'BlinkCmpMenuClose',
        callback = function()
          vim.b.copilot_suggestion_hidden = false
        end,
      })
    end,
  },
}
