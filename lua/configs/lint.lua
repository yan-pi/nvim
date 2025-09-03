local M = {}

function M.setup()
  local status_ok, lint = pcall(require, "lint")
  if not status_ok then
    return
  end

  lint.linters_by_ft = {
    javascript = { "eslint_d" }, -- Using eslint_d for better performance
    typescript = { "eslint_d" },
    javascriptreact = { "eslint_d" },
    typescriptreact = { "eslint_d" },
    python = { "flake8" },
    lua = { "luacheck" },
    go = { "golangcilint" },
    rust = { "clippy" },
    prisma = { "prisma-lint" },
  }

  lint.try_lint()

  -- Single autocmd for linting
  vim.api.nvim_create_autocmd({ "BufWritePost", "BufEnter" }, {
    callback = function()
      require("lint").try_lint()
    end,
  })
end

return M
