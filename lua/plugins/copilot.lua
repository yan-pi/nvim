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
            open = '<M-CR>',
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
            accept = '<M-l>',
            next = '<M-]>',
            prev = '<M-[>',
            dismiss = '<C-]>',
          },
        },
        nes = {
          enabled = true, -- Set to true if you want NES functionality and have copilot-lsp installed
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
  {
    'CopilotC-Nvim/CopilotChat.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
    },
    opts = {
      prompts = {
        Inline = {
          prompt = '',
          selection = 'buffer',
          show_prompt = false,
          mode = 'instant',
        },
        Explain = {
          prompt = 'Please explain how this code works.',
          selection = 'buffer',
        },
        Tests = 'Please help me write test cases for this code.',
        Refactor = 'Please refactor this code to improve readability and maintainability.',
        Fix = 'Identify and fix any bugs in this code.',
        Optimize = 'Optimize this code for better performance.',
        Docs = 'Add documentation comments to this code.',
        Commit = 'Write a conventional commit message for these changes.',
        Review = 'Code review this code and suggest improvements.',
      },
    },
    build = ':UpdateRemotePlugins',
    event = 'VeryLazy',
    keys = {
      {
        '<leader>cc',
        desc = '+Copilot Chat',
      },
      { '<leader>cci', '<cmd>CopilotChatInline<cr>', desc = 'Inline Chat', mode = { 'n', 'x' } },
      { '<leader>ccp', '<cmd>CopilotChatPrompt<cr>', desc = 'Custom Prompt', mode = { 'n', 'x' } },
      { '<leader>cce', '<cmd>CopilotChatExplain<cr>', desc = 'Explain Code' },
      { '<leader>ccs', '<cmd>CopilotChatSave<cr>', desc = 'Explain Code' },
      { '<leader>cct', '<cmd>CopilotChatTests<cr>', desc = 'Generate Tests' },
      { '<leader>ccr', '<cmd>CopilotChatRefactor<cr>', desc = 'Refactor Code' },
      { '<leader>ccf', '<cmd>CopilotChatFix<cr>', desc = 'Fix Code' },
      { '<leader>cco', '<cmd>CopilotChatOptimize<cr>', desc = 'Optimize Code' },
      { '<leader>ccd', '<cmd>CopilotChatDocs<cr>', desc = 'Add Documentation' },
      { '<leader>ccm', '<cmd>CopilotChatCommit<cr>', desc = 'Generate Commit Message' },
      { '<leader>ccv', '<cmd>CopilotChatReview<cr>', desc = 'Code Review' },
      { '<leader>ccy', '<cmd>CopilotChat<cr>', desc = 'Open Copilot Chat' },
    },
  },
}
