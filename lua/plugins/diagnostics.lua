return {
  {
    "folke/todo-comments.nvim",
    event = "BufReadPre",
    config = function()
      require("todo-comments").setup {}
    end,
  },
  {
    "mfussenegger/nvim-lint",
    event = { "BufWritePost", "BufReadPost", "InsertLeave" },
    config = function()
      require "configs.lint"
      -- Setup autocommand to trigger linting
      vim.api.nvim_create_autocmd({ "BufWritePost" }, {
        callback = function()
          require("nvim-lint").try_lint()
        end,
      })
    end,
  },
}
