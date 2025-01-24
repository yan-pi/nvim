return {
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    build = ":Copilot auth",
    opts = {
      suggestion = { enabled = false },
      panel = { enabled = false },
      filetypes = { markdown = true, help = true },
    },
  },
  { "zbirenbaum/copilot-cmp", opts = {}, dependencies = { "copilot.lua" } },
  {
    "github/copilot.vim",
    lazy = false,
    config = function()
      vim.g.copilot_no_tab_map = true
      vim.g.copilot_assume_mapped = true
    end,
  },
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    opts = {},
    build = function()
      vim.cmd "UpdateRemotePlugins"
    end,
    event = "VeryLazy",
    keys = {
      { "<leader>cce", "<cmd>CopilotChatExplain<cr>", desc = "CopilotChat - Explain code" },
      { "<leader>cct", "<cmd>CopilotChatTests<cr>", desc = "CopilotChat - Generate tests" },
      { "<leader>cco", "<cmd>CopilotChatOpen<cr>", desc = "CopilotChat - Open chat" },
    },
  },
}
