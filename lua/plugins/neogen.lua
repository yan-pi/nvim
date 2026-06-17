-- Auto-generate documentation stubs for functions, classes, types, files.
-- Reads signature via treesitter and emits the language's idiomatic doc
-- format (rustdoc ///, godoc //, TSDoc /** */).
--
-- Aligns with the project policy of doc-comments on all public APIs.
-- Keybind <leader>cD (capital D) to avoid collision with crates.nvim
-- <leader>cd (Crate Documentation, buffer-local in Cargo.toml).

return {
  {
    'danymat/neogen',
    cmd = 'Neogen',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    opts = {
      snippet_engine = 'luasnip',
      -- Language-specific templates moved to dedicated files:
      -- rust.lua, go.lua, web.lua, python.lua
      languages = {
        rust = { template = { annotation_convention = 'rustdoc' } },
        go = { template = { annotation_convention = 'godoc' } },
      },
    },
    keys = {
      { '<leader>cD', '<cmd>Neogen<cr>', desc = '[C]ode generate [D]oc' },
      { '<leader>cDf', '<cmd>Neogen func<cr>', desc = 'Doc function' },
      { '<leader>cDc', '<cmd>Neogen class<cr>', desc = 'Doc class/struct' },
      { '<leader>cDt', '<cmd>Neogen type<cr>', desc = 'Doc type' },
      { '<leader>cDF', '<cmd>Neogen file<cr>', desc = 'Doc file header' },
    },
  },
}
