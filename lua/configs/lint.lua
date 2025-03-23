local M = {}

function M.setup()
  local status_ok, lint = pcall(require, "lint")
  if not status_ok then
    return
  end

  lint.linters_by_ft = {
    javascript = { "eslint" },
    typescript = { "eslint" },
    javascriptreact = { "eslint" },
    typescriptreact = { "eslint" },
    python = { "flake8" },
    lua = { "luacheck" },
    go = { "golangcilint" },
  }

  vim.api.nvim_create_autocmd({ "BufWritePost", "BufEnter" }, {
    callback = function()
      require("lint").try_lint()
    end,
  })
end

return M
