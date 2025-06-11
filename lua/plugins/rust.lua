return {
  {
    "mrcjkb/rustaceanvim",
    version = "^4",
    ft = { "rust" },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "mfussenegger/nvim-dap",
    },
    config = function()
      vim.g.rustaceanvim = {
        tools = {
          reload_workspace_from_cargo_toml = true,
          inlay_hints = {
            auto = true,
          },
        },
        server = {
          on_attach = function(client, bufnr)
            -- Call the default on_attach if available
            local ok, nvlsp = pcall(require, "nvchad.configs.lspconfig")
            if ok then
              nvlsp.on_attach(client, bufnr)
            end

            -- Rust-specific keymaps
            vim.keymap.set("n", "<leader>ca", function() vim.cmd.RustLsp("codeAction") end,
              { desc = "Rust Code Action", buffer = bufnr })
            vim.keymap.set("n", "<leader>dr", function() vim.cmd.RustLsp("debuggables") end,
              { desc = "Rust Debuggables", buffer = bufnr })
            vim.keymap.set("n", "<leader>rr", function() vim.cmd.RustLsp("runnables") end,
              { desc = "Rust Runnables", buffer = bufnr })
            vim.keymap.set("n", "<leader>rt", function() vim.cmd.RustLsp("testables") end,
              { desc = "Rust Testables", buffer = bufnr })
            vim.keymap.set("n", "<leader>em", function() vim.cmd.RustLsp("expandMacro") end,
              { desc = "Expand Rust Macro", buffer = bufnr })
            vim.keymap.set("n", "<leader>eh", function() vim.cmd.RustLsp("explainError") end,
              { desc = "Explain Rust Error", buffer = bufnr })
          end,
          settings = {
            ["rust-analyzer"] = {
              cargo = {
                allFeatures = true,
                buildScripts = { enable = true },
              },
              checkOnSave = {
                command = "clippy",
                extraArgs = { "--no-deps" },
              },
              procMacro = { enable = true },
            }
          }
        },
        dap = { autoload_configurations = true },
      }
    end,
  },
  {
    "saecki/crates.nvim",
    ft = { "rust", "toml" },
    config = function()
      require("crates").setup()
    end,
  },
}
