return {
  {
    'nvim-mini/mini.nvim',
    version = '*',
    config = function()
      require('mini.files').setup {
        options = { use_as_default_explorer = true },
        mappings = {
          close = '<Esc>',
          go_in = 'l',
          go_in_plus = 'L',
          go_out = 'h',
          go_out_plus = 'H',
          synchronize = '=',
          show_help = 'g?',
        },
        windows = {
          preview = true,
          width_focus = 40,
          width_nofocus = 30,
        },
        content = {
          prefix = function() end,
        },
      }

      vim.api.nvim_create_autocmd('User', {
        pattern = 'MiniFilesBufferCreate',
        callback = function(args)
          vim.keymap.set('n', '<CR>', 'l', {
            buffer = args.data.buf_id,
            remap = true,
            desc = 'Enter directory/open file',
          })
        end,
      })

      require('mini.statusline').setup { use_icons = false }
      MiniStatusline.section_location = function()
        return '%2l:%-2v'
      end

      local function open_explorer(path)
        MiniFiles.open(path)
      end

      vim.keymap.set('n', '<leader>e', function()
        local file = vim.api.nvim_buf_get_name(0)
        open_explorer(file == '' and vim.fn.getcwd() or file)
      end, { desc = 'File explorer at current file' })
      vim.keymap.set('n', '<leader>E', function()
        open_explorer(vim.fn.getcwd())
      end, { desc = 'File explorer at working directory' })
    end,
  },
}
