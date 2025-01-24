return {
  {
    "stevearc/conform.nvim",
    event = "BufWritePre",
    opts = require "configs.conform",
  },
  {
    "jose-elias-alvarez/null-ls.nvim",
    config = function()
      local null_ls = require "null-ls"
      null_ls.setup {
        sources = {
          null_ls.builtins.diagnostics.eslint,
          null_ls.builtins.formatting.prettier,
        },
      }
    end,
  },
  {
    "MunifTanjim/prettier.nvim",
    lazy = false,
    config = function()
      local prettier = require "prettier"
      prettier.setup {
        bin = "prettierd",
        cli_options = { config_precedence = "prefer-file" },
        filetypes = { "css", "html", "javascript", "typescript", "markdown" },
      }
    end,
  },
  {
    "windwp/nvim-ts-autotag",
    ft = {
      "astro",
      "glimmer",
      "handlebars",
      "html",
      "javascript",
      "javascriptreact",
      "markdown",
      "php",
      "rescript",
      "svelte",
      "typescriptreact",
      "typescript",
      "vue",
      "xml",
    },
    config = function()
      require("nvim-ts-autotag").setup()
    end,
  },
}
