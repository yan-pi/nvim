return {
  {
    "3rd/image.nvim",
    config = function()
      require("image").setup {
        integrations = {
          markdown = {
            only_render_image_at_cursor = true,
            floating_windows = false,
            resolve_image_path = function(document_path, image_path, fallback)
              return "/home/yan/pesonal/Vault/Images/" .. image_path
            end,
          },
        },
      }
    end,
  },
}
