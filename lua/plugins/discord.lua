-- Discord Rich Presence via cord.nvim
return {
  'vyfor/cord.nvim',
  build = ':Cord update',
  event = 'VeryLazy',
  opts = {
    editor = {
      tooltip = 'Neovim',
    },
    display = {
      show_repository = true,
      show_cursor_position = true,
    },
    idle = {
      enabled = true,
      timeout = 300000, -- 5 minutes
      show_status = true,
    },
    text = {
      viewing = 'Viewing ${filename}',
      editing = 'Editing ${filename}',
      file_browser = 'Browsing files',
      plugin_manager = 'Managing plugins',
      workspace = 'In ${workspace}',
    },
    variables = true, -- Enable template variable interpolation
  },
}
