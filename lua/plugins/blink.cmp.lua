return {
  {
    "blink.cmp",
    dependencies = {
      "blink-cmp-copilot", -- Integração com Copilot
      "blink-cmp-dictionary", -- Fonte de dicionário
      "blink-emoji.nvim", -- Emojis
      "friendly-snippets", -- Snippets prontos
      "lazydev.nvim", -- Suporte ao Lazy.nvim
    },
    config = function()
      local cmp = require("blink.cmp")
      local luasnip = require("luasnip")

      -- Configuração básica do `cmp`
      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
          ["<Tab>"] = cmp.mapping.select_next_item(),
          ["<S-Tab>"] = cmp.mapping.select_prev_item(),
        }),
        sources = cmp.config.sources({
          { name = "copilot" },
          { name = "dictionary" },
          { name = "emoji" },
          { name = "snippets" },
        }),
      })
    end,
  },
}
