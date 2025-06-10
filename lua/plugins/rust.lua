return {
  -- Suporte avançado para Rust
  {
    "mrcjkb/rustaceanvim",
    version = "^4",
    ft = { "rust" },
    config = function()
      vim.g.rustaceanvim = {
        server = {
          on_attach = function(client, bufnr)
            -- Primeiro chama o on_attach padrão do NvChad
            local nvlsp = require("nvchad.configs.lspconfig")
            nvlsp.on_attach(client, bufnr)

            -- Keymappings específicos para Rust
            vim.keymap.set("n", "<leader>ca", function() vim.cmd.RustLsp("codeAction") end,
              { desc = "Rust Code Action", buffer = bufnr })
            vim.keymap.set("n", "<leader>dr", function() vim.cmd.RustLsp("debuggables") end,
              { desc = "Rust Debuggables", buffer = bufnr })
            vim.keymap.set("n", "<leader>rr", function() vim.cmd.RustLsp("runnables") end,
              { desc = "Rust Runnables", buffer = bufnr })
            vim.keymap.set("n", "<leader>em", function() vim.cmd.RustLsp("expandMacro") end,
              { desc = "Expand Rust Macro", buffer = bufnr })
            vim.keymap.set("n", "<leader>eh", function() vim.cmd.RustLsp("explainError") end,
              { desc = "Explain Rust Error", buffer = bufnr })
            vim.keymap.set("n", "<leader>rt", function() vim.cmd.RustLsp("testables") end,
              { desc = "Rust Testables", buffer = bufnr })
          end,
          settings = {
            -- Configurações para o rust-analyzer
            ["rust-analyzer"] = {
              cargo = {
                features = "all",
                buildScripts = { enable = true },
              },
              checkOnSave = {
                command = "clippy",
                extraArgs = { "--no-deps" },
              },
              procMacro = { enable = true },
              diagnostics = {
                experimental = { enable = true },
              },
            }
          }
        },
        -- Configuração para debugging
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
