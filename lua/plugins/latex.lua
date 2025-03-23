return {
  {
    "lervag/vimtex",
    lazy = false, -- Load when Neovim starts
    ft = { "tex", "latex" },
    config = function()
      -- PDF viewer settings
      vim.g.vimtex_view_method = "zathura" -- Use zathura as the PDF viewer
      -- Alternative viewers: 'mupdf', 'okular', 'evince', 'general'
      vim.g.vimtex_view_foward_search_on_start = false

      -- Compiler settings
      vim.g.vimtex_compiler_method = "latexmk"
      vim.g.vimtex_compiler_latexmk = {
        -- aux_dir = "/home/yan/Documents/latex/",
        -- out_dir = "/home/yan/Documents/latex/",
        -- build_dir = "/home/yan/Documents/latex/",
        callback = 1,
        continuous = 1,
        executable = "latexmk",
        options = {
          "-verbose",
          "-file-line-error",
          "-synctex=1",
          "-interaction=nonstopmode",
        },
      }

      -- TOC settings
      vim.g.vimtex_toc_config = {
        mode = 1,
        fold_enable = 0,
        hide_line_numbers = 1,
        resize = 0,
        refresh_always = 1,
      }

      -- Quickfix settings
      vim.g.vimtex_quickfix_mode = 0 -- Don't open quickfix automatically

      -- Enable custom mappings
      vim.g.vimtex_mappings_enabled = 1
    end,
  },
}
