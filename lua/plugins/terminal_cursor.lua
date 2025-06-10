return {
  {
    "NvChad/NvChad",
    optional = true,
    event = "VeryLazy",
    config = function()
      -- Detect terminal type
      local term = os.getenv("TERM_PROGRAM") or os.getenv("TERM")
      local is_kitty = term == "kitty" or vim.env.KITTY_WINDOW_ID

      if not is_kitty then
        return -- Only run for Kitty
      end

      -- Set up guicursor for proper cursor shapes and colors
      vim.opt.guicursor = {
        "n-v-c:block-Cursor/lCursor",
        "i-ci-ve:ver25-Cursor/lCursor",
        "r-cr:hor20-Cursor/lCursor",
        "o:hor50-Cursor/lCursor"
      }

      -- Function to send Kitty-specific cursor color commands
      local function set_cursor_color()
        local bg = vim.o.background

        if bg == "dark" then
          -- Light cursor for dark background
          io.write("\027]12;#ffffff\007")
        else
          -- Dark cursor for light background
          io.write("\027]12;#000000\007")
        end
        io.flush()
      end

      -- Set up autocommand for theme changes
      vim.api.nvim_create_autocmd("ColorScheme", {
        callback = set_cursor_color,
      })

      -- Apply on startup
      set_cursor_color()

      -- Restore cursor on exit
      vim.api.nvim_create_autocmd("VimLeave", {
        callback = function()
          io.write("\027]112\007") -- Reset to terminal default
          io.flush()
        end,
      })
    end
  }
}
