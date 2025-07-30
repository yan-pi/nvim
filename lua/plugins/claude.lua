return {
  -- Official-style Claude Code integration with WebSocket protocol
  {
    "coder/claudecode.nvim",
    event = "VeryLazy",
    config = function()
      require("claudecode").setup({
        -- Configuration options
        port = 8080,       -- WebSocket port (default: 8080)
        auto_start = true, -- Automatically start the server
        debug = false,     -- Enable debug logging
      })
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
