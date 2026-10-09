-- Standalone markdown-agenda.nvim plugin, installed through lazy.nvim.
return {
  {
    'yan-pi/markdown-agenda.nvim',
    main = 'markdown_agenda',
    dependencies = { 'folke/snacks.nvim' },
    opts = {
      files = {
        '~/www/vault/00-Index/001-Planning.md',
        -- Add more files here as needed.
      },
    },
    keys = {
      {
        '<leader>za',
        function()
          require('markdown_agenda').open()
        end,
        desc = 'Vault [A]genda (active)',
      },
      {
        '<leader>zA',
        function()
          require('markdown_agenda').open { all = true, title = 'Vault Agenda — all' }
        end,
        desc = 'Vault [A]genda (all incl. done)',
      },
      {
        '<leader>zi',
        function()
          require('markdown_agenda').open { filter = { DOING = true }, title = 'Vault DOING' }
        end,
        desc = 'Vault DOING',
      },
      {
        '<leader>zw',
        function()
          require('markdown_agenda').open { filter = { WAITING = true }, title = 'Vault WAITING' }
        end,
        desc = 'Vault WAITING',
      },
      {
        '<leader>zT',
        function()
          require('markdown_agenda').open { filter = { TODO = true }, title = 'Vault TODO' }
        end,
        desc = 'Vault TODO',
      },
      {
        '<leader>zx',
        function()
          require('markdown_agenda').cycle()
        end,
        desc = 'Cycle task status under cursor',
      },
    },
  },
}
