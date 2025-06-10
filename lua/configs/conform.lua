local conform = require "conform"

conform.setup {
  formatters_by_ft = {
    lua = { "stylua" },
    css = { "prettier" },
    html = { "prettier" },
    javascript = { "prettier" },
    typescript = { "prettier" },
    javascriptreact = { "prettier" },
    typescriptreact = { "prettier" },
    json = { "prettier" },
    markdown = { "prettier" },
    go = { "gofmt", "goimports" },
    prisma = { "prettier" },
    rust = { "rustfmt" },
  },
  format_on_save = {
    lsp_fallback = true,
    async = false,
    timeout_ms = 500,
  },
}
