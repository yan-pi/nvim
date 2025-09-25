-- Collection of various small independent plugins/modules

return {
  {
    'echasnovski/mini.nvim',
    config = function()
      -- Better Around/Inside textobjects
      --
      -- Examples:
      --  - va)  - [V]isually select [A]round [)]paren
      --  - yinq - [Y]ank [I]nside [N]ext [Q]uote
      --  - ci'  - [C]hange [I]nside [']quote
      -- require('mini.ai').setup { n_lines = 500 }

      -- File explorer with column view
      require('mini.files').setup {
        options = {
          use_as_default_explorer = true, -- Keep alongside netrw/telescope
        },
        mappings = {
          close = '<Esc>',       -- Escape to close (intuitive)
          go_in = 'l',           -- l to enter/open (vim-like)
          go_in_plus = 'L',      -- L for advanced entry
          go_out = 'h',          -- h for parent directory (vim-like)
          go_out_plus = 'H',     -- H for advanced parent
          mark_goto = "'",       -- Bookmark navigation
          mark_set = 'm',        -- Bookmark setting
          reset = '<BS>',        -- Backspace reset
          reveal_cwd = '@',      -- Reveal cwd
          show_help = 'g?',      -- Help
          synchronize = '=',     -- Sync (ESSENTIAL for saving changes)
          trim_left = '<',       -- Trim left
          trim_right = '>',      -- Trim right
        },
      }

      -- Add buffer-local Enter key support for mini.files
      vim.api.nvim_create_autocmd('User', {
        pattern = 'MiniFilesBufferCreate',
        callback = function(args)
          local buf_id = args.data.buf_id
          -- Add Enter as intuitive alternative to 'l'
          vim.keymap.set('n', '<CR>', 'l', {
            buffer = buf_id,
            remap = true,
            desc = 'Enter directory/open file'
          })
        end,
      })

      -- Fuzzy picker (lightweight alternative to Telescope)
      require('mini.pick').setup {
        options = {
          use_cache = true, -- Better performance
        },
      }

      -- Move lines and blocks with Alt+hjkl
      require('mini.move').setup() -- Uses default Alt+hjkl mappings

      -- Start screen
      require('mini.starter').setup()

      -- Navigate with ][ shortcuts (]b for next buffer, etc.)
      require('mini.bracketed').setup()

      -- Indent scope visualization
      require('mini.indentscope').setup()

      -- Add/delete/replace surroundings (brackets, quotes, etc.)
      --
      -- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
      -- - sd'   - [S]urround [D]elete [']quotes
      -- - sr)'  - [S]urround [R]eplace [)] [']
      require('mini.surround').setup()

      -- Simple and easy statusline.
      --  You could remove this setup call if you don't like it,
      --  and try some other statusline plugin
      local statusline = require 'mini.statusline'
      -- set use_icons to true if you have a Nerd Font
      statusline.setup { use_icons = vim.g.have_nerd_font }

      -- You can configure sections in the statusline by overriding their
      -- default behavior. For example, here we set the section for
      -- cursor location to LINE:COLUMN
      ---@diagnostic disable-next-line: duplicate-set-field
      statusline.section_location = function()
        return '%2l:%-2v'
      end

      -- === KEYMAPS ===

      -- Mini.files - File Explorer
      vim.keymap.set('n', '<leader>e', function()
        local current_file = vim.api.nvim_buf_get_name(0)
        -- Check if current buffer has a valid file path
        if current_file == '' or current_file:match('^%w+://') then
          -- Open at current working directory if no valid file or special buffer
          MiniFiles.open()
        else
          -- Open at current file's location
          MiniFiles.open(current_file)
        end
      end, { desc = 'File [E]xplorer (current file)' })

      vim.keymap.set('n', '<leader>E', function()
        MiniFiles.open()
      end, { desc = 'File [E]xplorer (cwd)' })

      -- Mini.pick - Fuzzy Picker
      vim.keymap.set('n', '<leader>pf', function()
        MiniPick.builtin.files()
      end, { desc = '[P]ick [F]iles' })

      vim.keymap.set('n', '<leader>pb', function()
        MiniPick.builtin.buffers()
      end, { desc = '[P]ick [B]uffers' })

      vim.keymap.set('n', '<leader>ph', function()
        MiniPick.builtin.help()
      end, { desc = '[P]ick [H]elp' })

      vim.keymap.set('n', '<leader>pg', function()
        MiniPick.builtin.grep_live()
      end, { desc = '[P]ick [G]rep Live' })

      -- Quick file picker (common IDE pattern)
      vim.keymap.set('n', '<C-p>', function()
        MiniPick.builtin.files()
      end, { desc = 'Pick Files (Ctrl+P)' })

      -- ... and there is more!
      --  Check out: https://github.com/echasnovski/mini.nvim
    end,
  },
}
