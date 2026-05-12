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
      viewing = function(opts) return 'Viewing ' .. opts.filename end,
      editing = function(opts)
        if opts.filename:match('claude%-prompt%-[^/]+%.[^/]+$') then
          return 'Editing config'
        end
        return 'Editing ' .. opts.filename
      end,
      file_browser = function(opts) return 'Browsing files in ' .. opts.name end,
      plugin_manager = function(opts) return 'Managing plugins in ' .. opts.name end,
      workspace = function(opts) return 'In ' .. opts.workspace end,
    },
  },
}
