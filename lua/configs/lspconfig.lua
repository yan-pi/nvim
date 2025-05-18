-- load defaults i.e lua_lsp
require("nvchad.configs.lspconfig").defaults()

local lspconfig = require "lspconfig"
local nvlsp = require "nvchad.configs.lspconfig"

-- Server configuration
local servers = {
  "html",        -- HTML
  "cssls",       -- CSS
  "tailwindcss", -- Tailwind
  "ts_ls",       -- TypeScript/JavaScript (corrected from ts_ls)
  "gopls",       -- Go
  "pyright",     -- Python
  "lua_ls",      -- Lua (corrected name)
  "prismals",    -- Prisma
}

for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_attach = nvlsp.on_attach,
    on_init = nvlsp.on_init,
    capabilities = nvlsp.capabilities,
  }
end

-- Configuração de diagnósticos globais
vim.diagnostic.config {
  virtual_text = true,
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true, -- Sort by severity
}
