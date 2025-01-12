return {
  {
    "lazydev.nvim",
    config = function()
      require("lazydev").setup({
        integrations = {
          blink = true,
        },
      })
    end,
  },
}
