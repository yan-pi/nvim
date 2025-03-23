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
  },
  format_on_save = {
    timeout_ms = 500,
    lsp_fallback = true,
  },
}
