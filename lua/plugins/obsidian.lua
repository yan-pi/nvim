-- lua/plugins/obsidian.lua
return {
  {
    'obsidian-nvim/obsidian.nvim', -- actively maintained fork
    version = '*',
    ft = { 'markdown' },
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts = {
      workspaces = {
        { name = 'Vault', path = '~/www/vault' },
      },

      notes_subdir = nil,
      new_notes_location = 'current_dir',
      legacy_commands = false,

      -- Folgezettel ID function (DDSSNN)
      note_id_func = function(title, path)
        local scandir = require 'plenary.scandir'
        local dir = vim.fn.fnamemodify(path, ':t')
        local dd = dir:match '^(%d%d)' or '10'
        local parent = vim.fn.fnamemodify(path, ':h:t')
        local ss = parent:match '^%d%d(%d%d)' or '01'
        local max_nn = 0
        for _, f in ipairs(scandir.scan_dir(path, { depth = 1 })) do
          local base = vim.fn.fnamemodify(f, ':t')
          local nn = base:match('^' .. dd .. ss .. '(%d%d)')
          if nn then
            max_nn = math.max(max_nn, tonumber(nn))
          end
        end
        local next_nn = string.format('%02d', max_nn + 1)
        local slug = (title and #title > 0) and ('-' .. title:lower():gsub('%W+', '-')) or ''
        return dd .. ss .. next_nn .. slug
      end,

      -- Frontmatter (new API)
      frontmatter = {
        enabled = true,
        func = function(note)
          return {
            id = note.id,
            title = note.title or '',
            tags = note.tags or {},
            aliases = note.aliases or {},
            created = os.date '%Y-%m-%d',
            modified = os.date '%Y-%m-%d',
          }
        end,
        sort = { 'id', 'title', 'tags', 'aliases', 'created', 'modified' },
      },

      -- Daily notes
      daily_notes = {
        folder = '40-Logbook/4001-Daily',
        date_format = '%Y-%m-%d',
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

      wiki_link_func = function(opts)
        if opts.id == nil then
          return string.format('[[%s]]', opts.label)
        elseif opts.label ~= opts.id then
          return string.format('[[%s|%s]]', opts.id, opts.label)
        else
          return string.format('[[%s]]', opts.id)
        end
      end,

      -- Disable UI features (avoids conceallevel warning)
      ui = {
        enable = false,
      },
    },

    -- Set up keymaps after plugin loads
    config = function(_, opts)
      require('obsidian').setup(opts)

      -- Keymaps for finding notes
      vim.keymap.set('n', '<leader>zf', '<cmd>Obsidian quick_switch<cr>', { desc = 'Find note' })
      vim.keymap.set('n', '<leader>zs', '<cmd>Obsidian search<cr>', { desc = 'Search notes' })
      vim.keymap.set('n', '<leader>zb', '<cmd>Obsidian backlinks<cr>', { desc = 'Show backlinks' })
      vim.keymap.set('n', '<leader>zl', '<cmd>Obsidian links<cr>', { desc = 'Show links' })
      vim.keymap.set('n', '<leader>zg', '<cmd>Obsidian tags<cr>', { desc = 'Browse tags' })

      -- Keymaps for creating notes
      vim.keymap.set('n', '<leader>zn', '<cmd>Obsidian new<cr>', { desc = 'New note' })
      vim.keymap.set('n', '<leader>zd', '<cmd>Obsidian today<cr>', { desc = 'Today daily note' })
      vim.keymap.set('n', '<leader>zy', '<cmd>Obsidian yesterday<cr>', { desc = 'Yesterday daily note' })
      vim.keymap.set('n', '<leader>zo', '<cmd>Obsidian open<cr>', { desc = 'Open in Obsidian app' })

      -- Follow link under cursor
      vim.keymap.set('n', 'gf', function()
        if require('obsidian').util.cursor_on_markdown_link() then
          return '<cmd>Obsidian follow_link<cr>'
        else
          return 'gf'
        end
      end, { expr = true, desc = 'Follow link' })
    end,
  },
}
