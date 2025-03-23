-- load defaults i.e lua_lsp
require("nvchad.configs.lspconfig").defaults()

local lspconfig = require "lspconfig"
local nvlsp = require "nvchad.configs.lspconfig"

-- Configuração para múltiplos servidores
local servers = { "html", "cssls", "tailwindcss", "ts_ls", "gopls" }

for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_attach = nvlsp.on_attach,
    on_init = nvlsp.on_init,
    capabilities = nvlsp.capabilities,
  }
end

-- Setup autocommand to trigger linting
vim.api.nvim_create_autocmd({ "BufWritePost" }, {
  callback = function()
    local ok, nvim_lint = pcall(require, "nvim-lint")
    if ok then
      nvim_lint.try_lint()
    end
  end,
})

-- Configuração de diagnósticos globais
vim.diagnostic.config {
  virtual_text = true,
  signs = true,
  underline = true,
  update_in_insert = false,
}
