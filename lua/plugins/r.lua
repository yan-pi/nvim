-- R language support
--
-- Stack:
--   * R.nvim         -> REPL, send code, object browser, completion, help viewer
--   * r_language_server (R package "languageserver") -> LSP (diagnostics, hover, refs)
--   * air            -> formatter (Posit's official R formatter, written in Rust)
--   * treesitter `r` parser -> syntax/indent
--
-- Pre-requisites (run once on the system):
--   R -e 'install.packages(c("languageserver", "httpgd"), repos = "https://cloud.r-project.org")'
--   brew install air-formatter   # or: cargo install air
--
-- LSP/treesitter/formatter wiring lives here so the whole R stack is in one file.

if not vim.g.lang_enabled.r then
  return {}
end

return {
  -- Main R IDE-like plugin: REPL, send code, object browser, help, plots
  {
    'R-nvim/R.nvim',
    ft = { 'r', 'rmd', 'quarto', 'rnoweb' },
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
    },
    opts = {
      R_args = { '--quiet', '--no-save' },
      hook = {
        on_filetype = function()
          vim.api.nvim_buf_set_keymap(0, 'n', '<Enter>', '<Plug>RDSendLine', {})
          vim.api.nvim_buf_set_keymap(0, 'v', '<Enter>', '<Plug>RSendSelection', {})
        end,
      },
      min_editor_width = 72,
      rconsole_width = 78,
      objbr_mappings = { c = 'class', s = 'str' },
      disable_cmds = { 'RClearConsole', 'RCustomStart' },
    },
    config = function(_, opts)
      require('r').setup(opts)

      -- Set up r_language_server here so we don't fight the main lsp.lua spec.
      -- Requires: R -e 'install.packages("languageserver")'
      local ok_blink, blink = pcall(require, 'blink.cmp')
      vim.lsp.config('r_language_server', {
        capabilities = ok_blink and blink.get_lsp_capabilities() or nil,
        settings = {
          r = {
            lsp = {
              rich_documentation = true,
              diagnostics = true,
            },
          },
        },
      })
      vim.lsp.enable('r_language_server')
    end,
  },

  -- Treesitter parsers for R + Rmd
  {
    'nvim-treesitter/nvim-treesitter',
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { 'r', 'markdown', 'markdown_inline' })
    end,
  },

  -- Formatter: air (Posit's R formatter)
  {
    'stevearc/conform.nvim',
    opts = function(_, opts)
      opts.formatters_by_ft = opts.formatters_by_ft or {}
      opts.formatters_by_ft.r = { 'air' }
      opts.formatters_by_ft.rmd = { 'air' }
      opts.formatters_by_ft.quarto = { 'air' }

      opts.formatters = opts.formatters or {}
      opts.formatters.air = {
        command = 'air-formatter',
        args = { 'format', '-' },
        stdin = true,
      }
      return opts
    end,
  },
}
