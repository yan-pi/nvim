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
      -- Toggle auto-format on save (global, all buffers)
      {
        '<leader>uf',
        function()
          vim.g.autoformat_enabled = not vim.g.autoformat_enabled
          local status = vim.g.autoformat_enabled and 'enabled' or 'disabled'
          vim.notify('Auto-format on save: ' .. status, vim.log.levels.INFO)
        end,
        desc = 'Toggle auto-format on save (global)',
      },
      -- Toggle auto-format on save (buffer-local)
      -- Useful for dotfiles/rc configs (e.g. .yabairc) you don't want
      -- auto-formatted, while keeping auto-format on elsewhere. Manual
      -- format via <leader>f still works regardless of this toggle.
      {
        '<leader>uF',
        function()
          -- Treat nil as enabled; only flip when explicitly disabled
          if vim.b.autoformat_enabled == false then
            vim.b.autoformat_enabled = nil
            vim.notify('Auto-format for buffer: enabled', vim.log.levels.INFO)
          else
            vim.b.autoformat_enabled = false
            vim.notify('Auto-format for buffer: disabled', vim.log.levels.INFO)
          end
        end,
        desc = 'Toggle auto-format on save (buffer)',
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
        -- Check buffer-local toggle first (nil = enabled, false = disabled).
        -- Lets you opt out of auto-format per-buffer (e.g. .yabairc) via
        -- <leader>uF without disabling it globally.
        if vim.b[bufnr].autoformat_enabled == false then
          return nil
        end

        -- Check global toggle
        if not vim.g.autoformat_enabled then
          return nil
        end

        -- Disable "format_on_save lsp_fallback" for languages that don't
        -- have a well standardized coding style. You can add additional
        -- languages here or re-enable it for the disabled ones.
        local disable_filetypes = {}
        if disable_filetypes[vim.bo[bufnr].filetype] then
          return nil
        else
          return {
            timeout_ms = 500,
            lsp_format = 'never', -- Don't use LSP for formatting, use configured formatters only
          }
        end
      end,
      -- formatters_by_ft is managed by language-specific files:
      -- lua.lua, python.lua, bash.lua, json.lua, yaml.lua, web.lua, markdown.lua, latex.lua, haskell.lua
    },
  },
}