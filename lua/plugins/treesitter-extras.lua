-- Treesitter-powered editing helpers:
--   ts-autotag: auto-close + auto-rename JSX/HTML/Vue/Svelte tags
--   treesj:     smart split/join of arguments, structs, match arms

return {
  {
    'windwp/nvim-ts-autotag',
    ft = { 'html', 'xml', 'jsx', 'tsx', 'vue', 'svelte', 'astro', 'php', 'markdown' },
    opts = {},
  },
  {
    'Wansmer/treesj',
    cmd = { 'TSJToggle', 'TSJSplit', 'TSJJoin' },
    opts = { use_default_keymaps = false, max_join_length = 150 },
    keys = {
      { '<leader>cj', '<cmd>TSJToggle<cr>', desc = '[C]ode split/[J]oin toggle' },
    },
  },
}
