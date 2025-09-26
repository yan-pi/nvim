return {
  -- Official-style Claude Code integration with WebSocket protocol
  {
    'coder/claudecode.nvim',
    event = 'BufReadPost',
    config = function()
      local status_ok, claudecode = pcall(require, 'claudecode')
      if not status_ok then
        vim.notify('Failed to load claudecode.nvim', vim.log.levels.ERROR)
        return
      end

      claudecode.setup {
        -- WebSocket server configuration
        port_range = { min = 8080, max = 8090 }, -- Port range for WebSocket server
        auto_start = true, -- Automatically start the server
        log_level = 'info', -- Log level: trace, debug, info, warn, error

        -- Selection tracking
        track_selection = true, -- Enable sending selection updates to Claude
        visual_demotion_delay_ms = 50, -- Delay before demoting visual selection

        -- Connection settings
        connection_wait_delay = 200, -- Wait time after connection before sending queued mentions
        connection_timeout = 10000, -- Max time to wait for Claude Code to connect (ms)
        queue_timeout = 5000, -- Max time to keep @ mentions in queue (ms)

        -- Diff options
        diff_opts = {
          auto_close_on_accept = true, -- Auto close diff after accepting
          show_diff_stats = true, -- Show diff statistics
          vertical_split = true, -- Use vertical split for diffs
          open_in_current_tab = false, -- Open diffs in current tab
        },

        -- Terminal configuration
        terminal = {
          split_side = 'right', -- Terminal position: "left" or "right"
          split_width_percentage = 40, -- Terminal width as percentage
          provider = 'auto', -- Terminal provider: "auto", "snacks", "native"
        },
      }
    end,
  },

  -- -- Alternative: Terminal-based Claude Code integration
  -- {
  --   "greggh/claude-code.nvim",
  --   enabled = false, -- Disable by default, enable if you prefer terminal approach
  --   config = function()
  --     require("claude-code").setup({
  --       -- Terminal configuration
  --       terminal = {
  --         -- Terminal size and position
  --         width = 0.8,
  --         height = 0.8,
  --         border = "rounded",
  --       },
  --       -- Auto-reload files modified by Claude Code
  --       auto_reload = true,
  --     })
  --   end,
  -- },

  -- -- Alternative: Direct Claude AI integration (not Claude Code CLI)
  -- {
  --   "IntoTheNull/claude.nvim",
  --   enabled = false, -- Disable by default
  --   dependencies = {
  --     "nvim-lua/plenary.nvim",
  --   },
  --   config = function()
  --     require("claude").setup({
  --       -- Add your Claude API key to environment or config
  --       -- api_key = os.getenv("CLAUDE_API_KEY"),
  --       model = "claude-3-5-sonnet-20241022",
  --       max_tokens = 4096,
  --     })
  --   end,
  -- },
}
