return {
  {
    "epwalsh/obsidian.nvim",
    version = "*",
    ft = "markdown",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      workspaces = {
        { name = "ZK", path = "~/Obsidian/Zettelkasten" },
      },
      notes_subdir = "2025",
      note_id_func = function(title)
        local ts = os.date("%Y%m%d%H%M")
        if title and #title > 0 then
          local slug = title:lower():gsub("%W+", "-")
          return ts .. "-" .. slug
        else
          return ts
        end
      end,
      note_frontmatter_func = function(note)
        local out = { id = note.id, aliases = note.aliases, tags = note.tags }
        if note.metadata then
          for k, v in pairs(note.metadata) do out[k] = v end
        end
        return out
      end,
      templates = { folder = "templates", date_format = "%Y-%m-%d", time_format = "%H:%M" },
      completion = { nvim_cmp = false, blink_cmp = true, min_chars = 2 },
      picker = { name = "telescope.nvim" },
      mappings = {},
    },
  },
}
