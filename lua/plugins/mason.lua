return {
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "lua-language-server",
        "stylua",
        "html-lsp",
        "css-lsp",
        "typescript-language-server",
        "prettier",
      },
    },
  },
  { "williamboman/mason-lspconfig.nvim" },
}
