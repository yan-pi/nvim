-- Git related plugins

return {
  -- Adds git related signs to the gutter, as well as utilities for managing changes
  {
    'lewis6991/gitsigns.nvim',
    event = { 'BufReadPre', 'BufNewFile' }, -- Lazy load for better startup
    opts = {
      signs = {
        add = { text = '┃' },
        change = { text = '┃' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
        untracked = { text = '┆' },
      },
      signs_staged = {
        add = { text = '┃' },
        change = { text = '┃' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
        untracked = { text = '┆' },
      },
      -- Performance optimizations
      max_file_length = 10000, -- Disable in files with >10k lines
      attach_to_untracked = false, -- Don't attach to untracked files
    },
  },
  {
    'f-person/git-blame.nvim',
    event = 'VeryLazy',
    opts = {
      enabled = false, -- Disabled by default for better scroll performance
      message_template = ' <author> • <summary> • <date> • <<sha>>',
      virtual_text_column = 1,
      max_file_size = 100 * 1024, -- 100KB - don't run on large files
    },
    keys = {
      {
        '<leader>gB',
        '<cmd>GitBlameToggle<cr>',
        desc = 'Toggle Git Blame',
      },
    },
  },
  {
    'akinsho/git-conflict.nvim',
    version = '*',
    config = true,
    default_mappings = true, -- disable buffer local mapping created by this plugin
    default_commands = true, -- disable commands created by this plugin
    disable_diagnostics = false, -- This will disable the diagnostics in a buffer whilst it is conflicted
    list_opener = 'copen', -- command or function to open the conflicts list
    highlights = { -- They must have background color, otherwise the default color will be used
      incoming = 'DiffAdd',
      current = 'DiffText',
    },
  },
}
