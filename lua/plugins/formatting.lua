-- Autoformat with project-aware formatter detection
-- Automatically detects project preferences (biome vs prettier) based on config files

-- Helper function for project-aware formatter detection
-- Searches upward from buffer location for formatter config files
-- Returns appropriate formatter(s) based on project configuration
--
-- @param bufnr number: Buffer number to detect formatter for
-- @param config_files table: List of config file patterns and their formatters
--   Format: { { files = {...}, formatters = {...} }, ... }
-- @param formatters table: Fallback formatters if no config found
--   Format: { default = {...} }
-- @return table: Formatter configuration for conform.nvim
local function detect_formatter(bufnr, config_files, formatters)
  -- Get the directory of the current buffer
  local root = vim.fs.dirname(vim.api.nvim_buf_get_name(bufnr))

  -- Search for config files in project root (upward search)
  for _, config in ipairs(config_files) do
    if vim.fs.find(config.files, { upward = true, path = root })[1] then
      return config.formatters
    end
  end

  -- Return default formatters if no config found
  return formatters.default
end

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
        -- Lua formatting
        lua = { 'stylua' },

        -- JavaScript and TypeScript formatting
        -- Project-aware: biome → prettierd → prettier (with fallback chain)
        -- Detects biome.json or .prettierrc in project root
        javascript = function(bufnr)
          return detect_formatter(bufnr, {
            -- Priority order: check biome first, then prettier
            { files = { 'biome.json', 'biome.jsonc' }, formatters = { 'biome' } },
            {
              files = { '.prettierrc', '.prettierrc.json', '.prettierrc.js', '.prettierrc.yml', 'prettier.config.js', 'prettier.config.cjs' },
              formatters = { 'prettierd', 'prettier', stop_after_first = true },
            },
          }, {
            -- Default: use prettierd with prettier fallback (faster than prettier alone)
            default = { 'prettierd', 'prettier', stop_after_first = true },
          })
        end,
        javascriptreact = function(bufnr)
          return detect_formatter(bufnr, {
            { files = { 'biome.json', 'biome.jsonc' }, formatters = { 'biome' } },
            {
              files = { '.prettierrc', '.prettierrc.json', '.prettierrc.js', '.prettierrc.yml', 'prettier.config.js', 'prettier.config.cjs' },
              formatters = { 'prettierd', 'prettier', stop_after_first = true },
            },
          }, {
            default = { 'prettierd', 'prettier', stop_after_first = true },
          })
        end,
        typescript = function(bufnr)
          return detect_formatter(bufnr, {
            { files = { 'biome.json', 'biome.jsonc' }, formatters = { 'biome' } },
            {
              files = { '.prettierrc', '.prettierrc.json', '.prettierrc.js', '.prettierrc.yml', 'prettier.config.js', 'prettier.config.cjs' },
              formatters = { 'prettierd', 'prettier', stop_after_first = true },
            },
          }, {
            default = { 'prettierd', 'prettier', stop_after_first = true },
          })
        end,
        typescriptreact = function(bufnr)
          return detect_formatter(bufnr, {
            { files = { 'biome.json', 'biome.jsonc' }, formatters = { 'biome' } },
            {
              files = { '.prettierrc', '.prettierrc.json', '.prettierrc.js', '.prettierrc.yml', 'prettier.config.js', 'prettier.config.cjs' },
              formatters = { 'prettierd', 'prettier', stop_after_first = true },
            },
          }, {
            default = { 'prettierd', 'prettier', stop_after_first = true },
          })
        end,

        -- Web technologies - project-aware
        html = function(bufnr)
          return detect_formatter(bufnr, {
            { files = { 'biome.json', 'biome.jsonc' }, formatters = { 'biome' } },
            {
              files = { '.prettierrc', '.prettierrc.json', '.prettierrc.js', '.prettierrc.yml', 'prettier.config.js', 'prettier.config.cjs' },
              formatters = { 'prettierd', 'prettier', stop_after_first = true },
            },
          }, {
            default = { 'prettierd', 'prettier', stop_after_first = true },
          })
        end,
        css = function(bufnr)
          return detect_formatter(bufnr, {
            { files = { 'biome.json', 'biome.jsonc' }, formatters = { 'biome' } },
            {
              files = { '.prettierrc', '.prettierrc.json', '.prettierrc.js', '.prettierrc.yml', 'prettier.config.js', 'prettier.config.cjs' },
              formatters = { 'prettierd', 'prettier', stop_after_first = true },
            },
          }, {
            default = { 'prettierd', 'prettier', stop_after_first = true },
          })
        end,
        scss = function(bufnr)
          return detect_formatter(bufnr, {
            { files = { 'biome.json', 'biome.jsonc' }, formatters = { 'biome' } },
            {
              files = { '.prettierrc', '.prettierrc.json', '.prettierrc.js', '.prettierrc.yml', 'prettier.config.js', 'prettier.config.cjs' },
              formatters = { 'prettierd', 'prettier', stop_after_first = true },
            },
          }, {
            default = { 'prettierd', 'prettier', stop_after_first = true },
          })
        end,

        -- JSON formatting - project-aware
        json = function(bufnr)
          return detect_formatter(bufnr, {
            { files = { 'biome.json', 'biome.jsonc' }, formatters = { 'biome' } },
            {
              files = { '.prettierrc', '.prettierrc.json', '.prettierrc.js', '.prettierrc.yml', 'prettier.config.js', 'prettier.config.cjs' },
              formatters = { 'prettierd', 'prettier', stop_after_first = true },
            },
          }, {
            default = { 'prettierd', 'prettier', stop_after_first = true },
          })
        end,
        jsonc = function(bufnr)
          return detect_formatter(bufnr, {
            { files = { 'biome.json', 'biome.jsonc' }, formatters = { 'biome' } },
            {
              files = { '.prettierrc', '.prettierrc.json', '.prettierrc.js', '.prettierrc.yml', 'prettier.config.js', 'prettier.config.cjs' },
              formatters = { 'prettierd', 'prettier', stop_after_first = true },
            },
          }, {
            default = { 'prettierd', 'prettier', stop_after_first = true },
          })
        end,

        -- Markdown formatting - project-aware
        markdown = function(bufnr)
          return detect_formatter(bufnr, {
            { files = { 'biome.json', 'biome.jsonc' }, formatters = { 'biome' } },
            {
              files = { '.prettierrc', '.prettierrc.json', '.prettierrc.js', '.prettierrc.yml', 'prettier.config.js', 'prettier.config.cjs' },
              formatters = { 'prettierd', 'prettier', stop_after_first = true },
            },
          }, {
            default = { 'prettierd', 'prettier', stop_after_first = true },
          })
        end,

        -- YAML formatting - project-aware
        yaml = function(bufnr)
          return detect_formatter(bufnr, {
            {
              files = { '.prettierrc', '.prettierrc.json', '.prettierrc.js', '.prettierrc.yml', 'prettier.config.js', 'prettier.config.cjs' },
              formatters = { 'prettierd', 'prettier', stop_after_first = true },
            },
          }, {
            default = { 'prettierd', 'prettier', stop_after_first = true },
          })
        end,
        yml = function(bufnr)
          return detect_formatter(bufnr, {
            {
              files = { '.prettierrc', '.prettierrc.json', '.prettierrc.js', '.prettierrc.yml', 'prettier.config.js', 'prettier.config.cjs' },
              formatters = { 'prettierd', 'prettier', stop_after_first = true },
            },
          }, {
            default = { 'prettierd', 'prettier', stop_after_first = true },
          })
        end,

        -- Python: Use Ruff for formatting (extremely fast, replaces black/isort)
        python = { 'ruff_format', 'ruff_organize_imports' },

        -- Rust: Use LSP formatting (rust_analyzer) as primary
        -- rust = {}, -- Handled by LSP

        -- Shell scripts
        sh = { 'shfmt' }, -- Can be installed via Mason if needed
        bash = { 'shfmt' },
      },
    },
  },
}