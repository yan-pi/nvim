return {
  -- add gruvbox
  { "ellisonleao/gruvbox.nvim" },

  -- add vesper
  -- { "datsfilipe/vesper.nvim" },

  --  kanagawa
  { "rebelot/kanagawa.nvim", lazy = true },

  -- Configure LazyVim to load gruvbox
  {
    "LazyVim/LazyVim",
    opts = {
      -- colorscheme = "catppuccin-frappe",
      -- colorscheme = "rose-pine-moon",
      colorscheme = "kanagawa",
      -- colorscheme = "vesper",
    },
  },
}
