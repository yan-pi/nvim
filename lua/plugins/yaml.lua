-- YAML language support
--
-- Stack:
--   * prettier/biome -> formatter (project-aware)
--   * treesitter     -> syntax highlighting
--
-- No LSP for YAML (no good one available).
-- Nix installs: (YAML is universal)

return {
  -- Formatter: project-aware (biome → prettier)
  {
    'stevearc/conform.nvim',
    opts = function(_, opts)
      opts.formatters_by_ft = opts.formatters_by_ft or {}
      local detect = require('core.formatting-utils').detect_formatter

      local yaml_fmt = function(bufnr)
        return detect(bufnr, {
          {
            files = { '.prettierrc', '.prettierrc.json', '.prettierrc.js', '.prettierrc.yml', 'prettier.config.js', 'prettier.config.cjs' },
            formatters = { 'prettierd', 'prettier', stop_after_first = true },
          },
        }, {
          default = { 'prettierd', 'prettier', stop_after_first = true },
        })
      end

      opts.formatters_by_ft.yaml = yaml_fmt
      opts.formatters_by_ft.yml = yaml_fmt
    end,
  },

  -- Treesitter: parser yaml
  {
    'nvim-treesitter/nvim-treesitter',
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { 'yaml' })
    end,
  },
}
