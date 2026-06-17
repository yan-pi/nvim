-- JSON language support
--
-- Stack:
--   * jsonls (LSP)  -> JSON validation with schema store
--   * prettier/biome -> formatter (project-aware)
--   * treesitter     -> syntax highlighting
--
-- Nix installs: (JSON is universal)
-- Mason installs: jsonls

return {
  -- LSP: jsonls with schema validation
  {
    'neovim/nvim-lspconfig',
    opts = function(_, opts)
      opts.servers = opts.servers or {}

      opts.servers.jsonls = {
        settings = {
          json = {
            schemas = require('schemastore').json.schemas(),
            validate = { enable = true },
          },
        },
      }
    end,
  },

  -- Formatter: project-aware (biome → prettier)
  {
    'stevearc/conform.nvim',
    opts = function(_, opts)
      opts.formatters_by_ft = opts.formatters_by_ft or {}
      local detect = require('core.formatting-utils').detect_formatter
      opts.formatters_by_ft.json = function(bufnr)
        return detect(bufnr, {
          { files = { 'biome.json', 'biome.jsonc' }, formatters = { 'biome' } },
          {
            files = { '.prettierrc', '.prettierrc.json', '.prettierrc.js', '.prettierrc.yml', 'prettier.config.js', 'prettier.config.cjs' },
            formatters = { 'prettierd', 'prettier', stop_after_first = true },
          },
        }, {
          default = { 'prettierd', 'prettier', stop_after_first = true },
        })
      end
    end,
  },

  -- Treesitter: parser json
  {
    'nvim-treesitter/nvim-treesitter',
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { 'json' })
    end,
  },
}
