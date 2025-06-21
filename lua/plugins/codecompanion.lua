return {
  {
    "olimorris/codecompanion.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "hrsh7th/nvim-cmp",
      "zbirenbaum/copilot.lua", -- Ensure copilot dependency
    },
    enabled = false,
    opts = {
      adapters = {
        chat = {
          copilot = {
            -- Copilot chat provider configuration
            model = "gpt-4",                                            -- You can specify which model to use
            temperature = 0.1,                                          -- Lower temperature for more focused responses
            max_tokens = 2000,                                          -- Increase token limit for longer responses
            system_prompt = "You are a helpful programming assistant.", -- Custom system prompt
          },
        },
        inline = {
          copilot = {
            -- Copilot inline code suggestions configuration
            auto_trigger = true, -- Automatically trigger suggestions
            accept_keymaps = {   -- Keymaps that match your copilot.lua configuration
              ["<M-l>"] = "Accept",
            },
            debounce = 100, -- Debounce time in ms
          },
        },
      },
      popup = {
        width = "80%",
        height = "80%",
        border = "rounded",
      },
      keymaps = {
        close = "q",
        submit = "<CR>",
        toggle_size = "t",
        suggestions = {
          accept = "<Tab>",
          reject = "<S-Tab>",
        },
      },
    },
    config = function(_, opts)
      require("codecompanion").setup(opts)
      vim.keymap.set("n", "<leader>ca", ":CodeCompanion<CR>", { desc = "Open Code Companion chat" })
      vim.keymap.set("v", "<leader>ca", ":CodeCompanion<CR>", { desc = "Open Code Companion with selection" })
      vim.keymap.set("n", "<leader>cs", ":CodeCompanionSuggestion<CR>", { desc = "Get code suggestion" })
      vim.keymap.set("n", "<leader>ce", ":CodeCompanionToggle<CR>", { desc = "Toggle Code Companion" })
    end,
  },
}
