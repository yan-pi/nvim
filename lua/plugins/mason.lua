return {
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    opts = {
      ui = {
        border = "rounded",
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        },
      },
    },
  },
  {
    "williamboman/mason-lspconfig.nvim",
    opts = {
      ensure_installed = {
        "lua-language-server",
        "stylua",
        "html-lsp",
        "css-lsp",
        "typescript-language-server",
        "prettier",
        "tailwindcss",
        "tsserver",
        "gopls",
      },
      automatic_installation = true,
    },
  },
  {
    "jay-babu/mason-null-ls.nvim",
    opts = {
      ensure_installed = {
        "prettier",
        "eslint_d",
        "gofmt",
        "goimports",
      },
      automatic_installation = true,
    },
  },
  -- {
  --   "williamboman/mason.nvim",
  --   opts = {
  --     ensure_installed = {
  --       "lua-language-server",
  --       "stylua",
  --       "html-lsp",
  --       "css-lsp",
  --       "typescript-language-server",
  --       "prettier",
  --     },
  --   },
  -- },
  -- { "williamboman/mason-lspconfig.nvim" },
}
