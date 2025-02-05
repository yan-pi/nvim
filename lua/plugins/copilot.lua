return {
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = { "InsertEnter", "BufReadPre" }, -- Load earlier for better experience
    config = function()
      require("copilot").setup {
        suggestion = {
          enabled = true,
          auto_trigger = true,
          keymap = {
            accept = "<M-l>",
            next = "<M-]>",
            prev = "<M-[>",
            dismiss = "<C-]>",
          },
        },
        panel = {
          enabled = true,
          auto_refresh = true, -- Changed to true for better UX
          keymap = {
            jump_prev = "[[",
            jump_next = "]]",
            accept = "<CR>",
            refresh = "gr",
            open = "<M-CR>",
          },
          layout = {
            position = "bottom",
            ratio = 0.4,
          },
        },
        -- Expanded filetypes support
        filetypes = {
          markdown = true,
          help = true,
          gitcommit = true,
          ["*"] = true, -- Enable for all filetypes
        },
      }
    end,
  },
  {
    "zbirenbaum/copilot-cmp",
    dependencies = { "copilot.lua" },
    config = function()
      require("copilot_cmp").setup()
    end,
  },
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    branch = "canary",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    opts = {
      prompts = {
        Inline = {
          prompt = "",
          selection = "buffer",
          show_prompt = false,
          mode = "instant",
        },
        Explain = {
          prompt = "Please explain how this code works.",
          selection = "buffer",
        },
        Tests = "Please help me write test cases for this code.",
        Refactor = "Please refactor this code to improve readability and maintainability.",
        Fix = "Identify and fix any bugs in this code.",
        Optimize = "Optimize this code for better performance.",
        Docs = "Add documentation comments to this code.",
        Commit = "Write a conventional commit message for these changes.",
        Review = "Code review this code and suggest improvements.",
      },
    },
    build = ":UpdateRemotePlugins", -- Fixed command syntax
    event = "VeryLazy",
    keys = {
      -- Reorganized keybindings for better consistency
      {
        "<leader>cc",
        desc = "+Copilot Chat",
      },
      { "<leader>cci", "<cmd>CopilotChatInline<cr>", desc = "Inline Chat", mode = { "n", "x" } },
      { "<leader>ccp", "<cmd>CopilotChatPrompt ", desc = "Custom Prompt", mode = { "n", "x" } },
      { "<leader>cce", "<cmd>CopilotChatExplain<cr>", desc = "Explain Code" },
      { "<leader>cct", "<cmd>CopilotChatTests<cr>", desc = "Generate Tests" },
      { "<leader>ccr", "<cmd>CopilotChatRefactor<cr>", desc = "Refactor Code" },
      { "<leader>ccf", "<cmd>CopilotChatFix<cr>", desc = "Fix Code" },
      { "<leader>cco", "<cmd>CopilotChatOptimize<cr>", desc = "Optimize Code" },
      { "<leader>ccd", "<cmd>CopilotChatDocs<cr>", desc = "Add Documentation" },
      { "<leader>ccm", "<cmd>CopilotChatCommit<cr>", desc = "Generate Commit Message" },
      { "<leader>ccv", "<cmd>CopilotChatReview<cr>", desc = "Code Review" },
      { "<leader>ccy", "<cmd>CopilotChat<cr>", desc = "Open Copilot Chat" }, -- New keybinding
    },
  },
}
