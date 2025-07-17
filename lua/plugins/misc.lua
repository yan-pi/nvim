return {
  { "wakatime/vim-wakatime", lazy = false },
  {
    "m4xshen/hardtime.nvim",
    lazy = false,
    dependencies = { "MunifTanjim/nui.nvim" },
    opts = {
      enabled = false, -- Start with the plugin disabled
    },
  },
  {
    "nvzone/floaterm",
    dependencies = "nvzone/volt",
    opts = {
      border = true
    },
    cmd = "FloatermToggle",
    keys = {
      { "<leader>fn", "<cmd>FloatermToggle<cr>", desc = "Toggle Floaterm" },
    },
  }
}
