-- load defaults i.e lua_lsp
require("nvchad.configs.lspconfig").defaults()

local lspconfig = require "lspconfig"
local nvlsp = require "nvchad.configs.lspconfig"

local servers = {
  "html",          -- HTML
  "cssls",         -- CSS
  "tailwindcss",   -- Tailwind
  "ts_ls",         -- TypeScript/JavaScript
  "gopls",         -- Go
  "pyright",       -- Python
  "lua_ls",        -- Lua (corrected name)
  "prismals",      -- Prisma
  "marksman",      -- Markdown Language Server
  "rust_analyzer", -- Rust Language Server
}

for _, lsp in ipairs(servers) do
  if lsp == "rust_analyzer" then
    -- Skip the built-in rust_analyzer setup since rustaceanvim handles it
    goto continue
  else
    lspconfig[lsp].setup {
      on_attach = nvlsp.on_attach,
      on_init = nvlsp.on_init,
      capabilities = nvlsp.capabilities,
    }
  end
  ::continue::
end

-- Configuração de diagnósticos globais
vim.diagnostic.config {
  virtual_text = true,
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true, -- Sort by severity
}
