-- lua/plugins/obsidian.lua
return {
  {
    "epwalsh/obsidian.nvim",
    version = "*",
    ft = { "markdown" },
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      -- 1) único workspace na raiz
      workspaces            = {
        { name = "Vault", path = "~/www/Vault" },
      },

      -- 2) sem notes_subdir fixo
      notes_subdir          = nil,

      -- 3) ID Folgezettel (DDSSNN)
      note_id_func          = function(title, _filename, path)
        local scandir = require("plenary.scandir")
        -- extrai DD
        local dir = vim.fn.fnamemodify(path, ":t")
        local dd = dir:match("^(%d%d)") or "10"
        -- extrai SS
        local parent = vim.fn.fnamemodify(path, ":h:t")
        local ss = parent:match("^%d%d(%d%d)") or "01"

        -- achar maior NN
        local max_nn = 0
        for _, f in ipairs(scandir.scan_dir(path, { depth = 1 })) do
          local base = vim.fn.fnamemodify(f, ":t")
          local nn = base:match("^" .. dd .. ss .. "(%d%d)")
          if nn then
            max_nn = math.max(max_nn, tonumber(nn))
          end
        end
        local next_nn = string.format("%02d", max_nn + 1)
        local slug = (title and #title > 0) and ("-" .. title:lower():gsub("%W+", "-")) or ""
        return dd .. ss .. next_nn .. slug
      end,

      -- 4) frontmatter
      note_frontmatter_func = function(note)
        return {
          id       = note.id,
          title    = note.title or "",
          tags     = note.tags or {},
          aliases  = note.aliases or {},
          created  = os.date("%Y-%m-%d"),
          modified = os.date("%Y-%m-%d"),
        }
      end,

      -- 5) templates
      templates             = {
        folder      = "_Templates",
        date_format = "%Y-%m-%d",
        time_format = "%H:%M",
      },

      -- 6) completion & picker
      completion            = { nvim_cmp = true, blink_cmp = true, min_chars = 2 },
      picker                = { name = "telescope.nvim" },

      -- 7) tipos de notas personalizadas
      note_map              = {
        Index = { subdir = "00-Index", template = "[YYYY-MM-DD]" },
        Theme = { subdir = "10-Themes", template = "[YYYY-MM-DD]" },
        Project = { subdir = "20-Projects", template = "[YYYY-MM-DD]" },
        Resource = { subdir = "30-Resources", template = "[YYYY-MM-DD]" },
        Daily = { subdir = "40-Logbook/4001-Daily", template = "[YYYY-MM-DD]" },
        Weekly = { subdir = "40-Logbook/4002-Weekly", template = "[YYYY-MM-DD]" },
        Monthly = { subdir = "40-Logbook/4003-Monthy", template = "[YYYY-MM-DD]" },
      },


      -- Adicionar configurações necessárias para links
      new_notes_location = "current_dir",
      wiki_link_func     = function(opts)
        if opts.id == nil then
          return string.format("[[%s]]", opts.label)
        elseif opts.label ~= opts.id then
          return string.format("[[%s|%s]]", opts.id, opts.label)
        else
          return string.format("[[%s]]", opts.id)
        end
      end,

      -- 8) mapeamentos
      mappings           = {
        ["<leader>zi"] = { action = function() require("obsidian").new_note("Index") end, opts = { noremap = true, silent = true } },
        ["<leader>zt"] = { action = function() require("obsidian").new_note("Theme") end, opts = { noremap = true, silent = true } },
        ["<leader>zp"] = { action = function() require("obsidian").new_note("Project") end, opts = { noremap = true, silent = true } },
        ["<leader>zr"] = { action = function() require("obsidian").new_note("Resource") end, opts = { noremap = true, silent = true } },
        ["<leader>zd"] = { action = function() require("obsidian").new_note("Daily") end, opts = { noremap = true, silent = true } },
        ["<leader>zw"] = { action = function() require("obsidian").new_note("Weekly") end, opts = { noremap = true, silent = true } },
        ["<leader>zm"] = { action = function() require("obsidian").new_note("Monthly") end, opts = { noremap = true, silent = true } },
      },
    },
  },
}
