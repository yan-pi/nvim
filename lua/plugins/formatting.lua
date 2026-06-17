-- Autoformat with project-aware formatter detection
-- Automatically detects project preferences (biome vs prettier) based on config files

-- Import shared formatting utilities
local formatting_utils = require 'core.formatting-utils'
local detect_formatter = formatting_utils.detect_formatter

return {
  {
    'stevearc/conform.nvim',
    event = { 'BufWritePre' },
    cmd = { 'ConformInfo' },
    keys = {
      {
        '<leader>f',
        function()
          require('conform').format { async = true, lsp_format = 'never' }
        end,
        mode = '',
        desc = '[F]ormat buffer',
      },
      -- Toggle auto-format on save
      {
        '<leader>uf',
        function()
          vim.g.autoformat_enabled = not vim.g.autoformat_enabled
          local status = vim.g.autoformat_enabled and 'enabled' or 'disabled'
          vim.notify('Auto-format on save: ' .. status, vim.log.levels.INFO)
        end,
        desc = 'Toggle auto-format on save',
      },
    },
    init = function()
      -- Enable auto-format by default
      vim.g.autoformat_enabled = true
    end,
    opts = {
      notify_on_error = false,
      formatters = {
        -- Configure prettier to use project config and ignore ESLint formatting rules
        prettier = {
          prepend_args = { '--config-precedence', 'prefer-file' },
        },
        -- Configure prettierd (faster prettier daemon) similarly
        prettierd = {
          prepend_args = { '--config-precedence', 'prefer-file' },
        },
      },
      format_on_save = function(bufnr)
        -- Check global toggle
        if not vim.g.autoformat_enabled then
          return nil
        end

        -- Disable "format_on_save lsp_fallback" for languages that don't
        -- have a well standardized coding style. You can add additional
        -- languages here or re-enable it for the disabled ones.
        local disable_filetypes = { c = true, cpp = true }
        if disable_filetypes[vim.bo[bufnr].filetype] then
          return nil
        else
          return {
            timeout_ms = 500,
            lsp_format = 'never', -- Don't use LSP for formatting, use configured formatters only
          }
        end
      end,
      formatters_by_ft = {
        -- Linguagens específicas movidas para arquivos dedicados:
        -- lua.lua, python.lua, bash.lua, json.lua, yaml.lua, web.lua
        --
        -- Formatters remaining here (not yet moved to dedicated files):
      },
    },
  },
}