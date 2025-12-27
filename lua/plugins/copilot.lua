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
  {
    'CopilotC-Nvim/CopilotChat.nvim',
    branch = 'main',
    dependencies = {
      'nvim-lua/plenary.nvim',
    },
    cmd = 'CopilotChat',
    opts = function()
      local user = vim.env.USER or 'User'
      user = user:sub(1, 1):upper() .. user:sub(2)
      return {
        auto_insert_mode = true,
        show_help = true,
        question_header = '  ' .. user .. ' ',
        answer_header = '  Copilot ',
        window = {
          width = 0.4,
        },
        prompts = {
          Explain = {
            prompt = 'Please explain how this code works.',
          },
          Tests = 'Please help me write test cases for this code.',
          Refactor = 'Please refactor this code to improve readability and maintainability.',
          Fix = 'Identify and fix any bugs in this code.',
          Optimize = 'Optimize this code for better performance.',
          Docs = 'Add documentation comments to this code.',
          Commit = 'Write a conventional commit message for these changes.',
          Review = 'Code review this code and suggest improvements.',
        },
      }
    end,
    config = function(_, opts)
      local chat = require 'CopilotChat'

      -- Disable line numbers in copilot-chat buffers
      vim.api.nvim_create_autocmd('BufEnter', {
        pattern = 'copilot-chat',
        callback = function()
          vim.opt_local.relativenumber = false
          vim.opt_local.number = false
        end,
      })

      chat.setup(opts)
    end,
    keys = {
      -- Group descriptor
      { '<leader>cc', desc = '+Copilot Chat', mode = { 'n', 'x' } },

      -- Toggle chat window (main interface)
      {
        '<leader>ccy',
        function()
          require('CopilotChat').toggle()
        end,
        desc = 'Toggle Chat',
        mode = { 'n', 'x' },
      },

      -- Quick chat with input prompt
      {
        '<leader>ccq',
        function()
          vim.ui.input({ prompt = 'Quick Chat: ' }, function(input)
            if input ~= '' then
              require('CopilotChat').ask(input)
            end
          end)
        end,
        desc = 'Quick Chat',
        mode = { 'n', 'x' },
      },

      -- Inline chat - floating window at cursor
      {
        '<leader>cci',
        function()
          vim.ui.input({ prompt = 'Inline Chat: ' }, function(input)
            if input ~= '' then
              require('CopilotChat').ask(input, {
                window = {
                  layout = 'float',
                  relative = 'cursor',
                  width = 1,
                  height = 0.4,
                  row = 1,
                },
              })
            end
          end)
        end,
        desc = 'Inline Chat (at cursor)',
        mode = { 'n', 'x' },
      },

      -- Reset chat
      {
        '<leader>ccx',
        function()
          require('CopilotChat').reset()
        end,
        desc = 'Clear Chat',
        mode = { 'n', 'x' },
      },

      -- Prompt actions menu
      {
        '<leader>ccp',
        function()
          local actions = require 'CopilotChat.actions'
          require('CopilotChat.integrations.telescope').pick(actions.prompt_actions())
        end,
        desc = 'Prompt Actions',
        mode = { 'n', 'x' },
      },

      -- Existing prompt shortcuts
      { '<leader>cce', '<cmd>CopilotChatExplain<cr>', desc = 'Explain Code', mode = { 'n', 'x' } },
      { '<leader>cct', '<cmd>CopilotChatTests<cr>', desc = 'Generate Tests', mode = { 'n', 'x' } },
      { '<leader>ccr', '<cmd>CopilotChatRefactor<cr>', desc = 'Refactor Code', mode = { 'n', 'x' } },
      { '<leader>ccf', '<cmd>CopilotChatFix<cr>', desc = 'Fix Code', mode = { 'n', 'x' } },
      { '<leader>cco', '<cmd>CopilotChatOptimize<cr>', desc = 'Optimize Code', mode = { 'n', 'x' } },
      { '<leader>ccd', '<cmd>CopilotChatDocs<cr>', desc = 'Add Documentation', mode = { 'n', 'x' } },
      { '<leader>ccm', '<cmd>CopilotChatCommit<cr>', desc = 'Generate Commit', mode = { 'n', 'x' } },
      { '<leader>ccv', '<cmd>CopilotChatReview<cr>', desc = 'Code Review', mode = { 'n', 'x' } },
    },
  },
}
