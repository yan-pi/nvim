-- Formatting utilities shared across language-specific plugin files
--
-- Provides project-aware formatter detection for conform.nvim.
-- Searches upward from buffer location for formatter config files.

local M = {}

--- Detect formatter based on project config files
--- @param bufnr number Buffer number to detect formatter for
--- @param config_files table List of config file patterns and their formatters
---   Format: { { files = {...}, formatters = {...} }, ... }
--- @param formatters table Fallback formatters if no config found
---   Format: { default = {...} }
--- @return table Formatter configuration for conform.nvim
function M.detect_formatter(bufnr, config_files, formatters)
  local root = vim.fs.dirname(vim.api.nvim_buf_get_name(bufnr))

  for _, config in ipairs(config_files) do
    if vim.fs.find(config.files, { upward = true, path = root })[1] then
      return config.formatters
    end
  end

  return formatters.default
end

return M
