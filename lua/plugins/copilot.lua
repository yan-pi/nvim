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
        suggestion = { enabled = true, auto_trigger = true },
        nes = {
          enabled = false, -- Set to true if you want NES functionality and have copilot-lsp installed
        },
        copilot_node_command = 'node', -- Node.js version must be > 20
        server_opts_overrides = {
          settings = {
            advanced = {
              model = 'gpt-5.4-mini',
              temperature = 0.15,
              top_p = 0.95,
              listCount = 10,
              inlineSuggestCount = 5,
              length = 500,
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
        model = 'gpt-5.4-mini',
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

      -- Disable line numbers and add custom keymaps in copilot-chat buffers
      vim.api.nvim_create_autocmd('BufEnter', {
        pattern = 'copilot-chat',
        callback = function()
          vim.opt_local.relativenumber = false
          vim.opt_local.number = false

          -- Custom keymaps for faster diff acceptance
          vim.keymap.set('n', '<C-a>', function()
            -- Accept all diffs in the chat buffer
            local actions = require 'CopilotChat.actions'
            local diff = actions.diff_hunks()
            if diff then
              for _, hunk in ipairs(diff) do
                vim.cmd 'normal! <C-y>'
              end
              vim.notify('✓ All diffs accepted', vim.log.levels.INFO)
            end
          end, { buffer = true, desc = 'Accept All Diffs' })

          vim.keymap.set('n', 'q', function()
            chat.close()
          end, { buffer = true, desc = 'Close Chat' })
        end,
      })

      chat.setup(opts)
    end,
    keys = {
      { '<leader>cc', desc = '+Copilot Chat', mode = { 'n', 'x' } },

      -- Inline floating chat at cursor — primary entry point.
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
                callback = function()
                  vim.schedule(function()
                    local chat_win = vim.fn.bufwinid(vim.fn.bufnr 'copilot-chat')
                    if chat_win ~= -1 then
                      vim.api.nvim_set_current_win(chat_win)
                      vim.notify('Press <C-y> to accept diff, <C-a> to accept all, or q to close', vim.log.levels.INFO)
                    end
                  end)
                end,
              })
            end
          end)
        end,
        desc = 'Inline Chat (at cursor)',
        mode = { 'n', 'x' },
      },

      -- Prompt actions picker — covers Explain/Tests/Refactor/Fix/Optimize/Docs/Commit/Review.
      {
        '<leader>ccp',
        function()
          local actions = require('CopilotChat.actions').prompt_actions()
          local items = {}
          for name, action in pairs(actions) do
            table.insert(items, { text = name, action = action })
          end
          Snacks.picker.pick {
            items = items,
            format = function(item)
              return item.text
            end,
            confirm = function(item)
              vim.cmd(item.action)
            end,
          }
        end,
        desc = 'Chat Prompt Actions',
        mode = { 'n', 'x' },
      },

      {
        '<leader>ccx',
        function()
          require('CopilotChat').reset()
        end,
        desc = 'Clear Chat',
        mode = { 'n', 'x' },
      },
    },
  },
}
