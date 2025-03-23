return {
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    keys = {
      {
        "<leader>fm",
        function()
          require("conform").format { timeout_ms = 1000, lsp_fallback = true }
        end,
        desc = "Format Document",
      },
    },
    config = function()
      require "configs.conform"
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
