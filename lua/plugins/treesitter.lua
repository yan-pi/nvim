return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        -- "vim",
        -- "lua",
        -- "vimdoc",
        -- "html",
        -- "css",
        -- "rust",
        -- "json",
        -- "yaml",
        -- "toml",
        -- "bash",
        -- "python",
        -- "javascript",
        -- "typescript",
        -- "go", -- Adicionado Go
        "latex",
        "markdown",
        "markdown_inline", -- Para melhor renderização do markdown
      },
    }
  },
}
