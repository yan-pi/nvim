-- lua/plugins/obsidian.lua
local workflow = require 'vault.obsidian_workflow'

return {
  {
    'obsidian-nvim/obsidian.nvim', -- actively maintained fork
    version = '*',
    ft = { 'markdown' },
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts = {
      workspaces = {
        { name = 'Vault', path = '~/vault' },
      },

      notes_subdir = '00-Inbox',
      new_notes_location = 'notes_subdir',
      legacy_commands = false,

      -- Generic Obsidian notes go to Inbox with a readable filename.
      -- Semantic concept IDs are created by vault.obsidian_workflow.
      note_id_func = function(title)
        local slug = workflow.slugify(title)
        return slug ~= '' and slug or 'untitled'
      end,

      frontmatter = {
        enabled = true,
        func = workflow.frontmatter,
        sort = {
          'id',
          'type',
          'title',
          'primary_topic',
          'topics',
          'aliases',
          'legacy_id',
          'status',
          'source_type',
          'author',
          'url',
          'concepts',
          'created',
          'modified',
          'captured',
          'tags',
        },
      },

      -- Daily notes
      daily_notes = {
        folder = '40-Logbook/Daily',
        date_format = '%Y-%m-%d',
        template = '[YYYY-MM-DD].md',
      },

      templates = {
        folder = '_Templates',
        date_format = '%Y-%m-%d',
        time_format = '%H:%M',
      },

      -- Completion auto-detects blink vs nvim-cmp
      completion = {
        min_chars = 2,
      },

      -- The vault uses Obsidian wikilinks.
      link = {
        style = 'wiki',
      },

      -- Disable UI features (avoids conceallevel warning)
      ui = {
        enable = false,
      },
    },

    -- Set up keymaps after plugin loads
    config = function(_, opts)
      require('obsidian').setup(opts)
      workflow.setup()

      -- Navigation and search
      vim.keymap.set('n', '<leader>zf', '<cmd>Obsidian quick_switch<cr>', { desc = 'Find note' })
      vim.keymap.set('n', '<leader>zs', '<cmd>Obsidian search<cr>', { desc = 'Search notes' })
      vim.keymap.set('n', '<leader>zb', '<cmd>Obsidian backlinks<cr>', { desc = 'Show backlinks' })
      vim.keymap.set('n', '<leader>zl', '<cmd>Obsidian links<cr>', { desc = 'Show links' })
      vim.keymap.set('n', '<leader>zt', '<cmd>Obsidian tags<cr>', { desc = 'Browse tags' })

      -- Vault workflow
      vim.keymap.set('n', '<leader>zn', '<cmd>VaultCapture<cr>', { desc = 'Capture in Inbox' })
      vim.keymap.set('n', '<leader>zr', '<cmd>VaultSource<cr>', { desc = 'Create source note' })
      vim.keymap.set('n', '<leader>zc', '<cmd>VaultConceptRelated<cr>', { desc = 'Create related concept' })
      vim.keymap.set('n', '<leader>zC', '<cmd>VaultConceptChild<cr>', { desc = 'Create child concept' })
      vim.keymap.set('n', '<leader>zg', '<cmd>VaultConceptFamily<cr>', { desc = 'Create concept family' })
      vim.keymap.set('n', '<leader>zd', '<cmd>Obsidian today<cr>', { desc = 'Today daily note' })
      vim.keymap.set('n', '<leader>zy', '<cmd>Obsidian yesterday<cr>', { desc = 'Yesterday daily note' })
      vim.keymap.set('n', '<leader>zo', '<cmd>Obsidian open<cr>', { desc = 'Open in Obsidian app' })

      -- Follow link under cursor
      vim.keymap.set('n', 'gf', function()
        if require('obsidian').util.cursor_on_markdown_link() then
          return '<cmd>Obsidian follow_link<cr>'
        end
        return 'gf'
      end, { expr = true, desc = 'Follow link' })
    end,
  },
}
