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
        "lua_ls", -- Lua
        "html", -- HTML
        "cssls", -- CSS
        "ts_ls", -- TypeScript/JavaScript
        "tailwindcss", -- Tailwind CSS
        "gopls", -- Go
        "pyright", -- Python (added)
      },
      automatic_installation = true,
    },
  },
}
