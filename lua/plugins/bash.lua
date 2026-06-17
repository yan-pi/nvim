-- Bash/Shell language support
--
-- Stack:
--   * bashls (LSP)  -> shell script analysis
--   * shfmt         -> formatter
--   * treesitter    -> syntax highlighting
--
-- Nix installs: (bash is system-provided)
-- Mason installs: bashls, shfmt

return {
  -- LSP: bashls
  {
    'neovim/nvim-lspconfig',
    opts = function(_, opts)
      opts.servers = opts.servers or {}

      opts.servers.bashls = {
        filetypes = { 'sh', 'bash', 'zsh' },
      }
    end,
  },

  -- Formatter: shfmt
  {
    'stevearc/conform.nvim',
    opts = function(_, opts)
      opts.formatters_by_ft = opts.formatters_by_ft or {}
      opts.formatters_by_ft.sh = { 'shfmt' }
      opts.formatters_by_ft.bash = { 'shfmt' }
    end,
  },

  -- Treesitter: parser bash
  {
    'nvim-treesitter/nvim-treesitter',
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { 'bash' })
    end,
  },
}
