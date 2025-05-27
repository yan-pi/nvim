---@diagnostic disable: undefined-global
return {
  {
    "kawre/leetcode.nvim",
    build = ":TSUpdate html", -- if you have `nvim-treesitter` installed
    dependencies = {
      "nvim-telescope/telescope.nvim",
      -- "ibhagwan/fzf-lua",
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "nvim-web-devicons", -- for better icons
    },
    cmd = "Leet",          -- Lazy loading por comando
    ft = "leetcode",       -- Lazy loading por filetype
    opts = {
      arg = "leetcode.nvim",
      lang = "go", -- linguagem padrão

      cn = {       -- leetcode.cn
        enabled = false,
        translator = true,
        translate_problems = true,
      },

      storage = {
        home = vim.fn.stdpath("data") .. "/leetcode",
        cache = vim.fn.stdpath("cache") .. "/leetcode",
      },

      plugins = {
        non_standalone = true, -- Permite usar dentro do Neovim normal
      },

      logging = true,

      -- 🆕 CACHE - Configuração melhorada
      cache = {
        update_interval = 60 * 60 * 24 * 3, -- 3 dias ao invés de 7 para manter cache mais atualizado
      },

      -- 🆕 CONSOLE - Configurações aprimoradas
      console = {
        open_on_runcode = true,
        dir = "row",      -- ou "col" para divisão vertical
        size = {
          width = "95%",  -- Aumentado para melhor visualização
          height = "80%", -- Aumentado para melhor visualização
        },
        result = {
          size = "65%", -- Mais espaço para resultados
        },
        testcase = {
          virt_text = true,
          size = "35%",
        },
      },

      -- 🆕 DESCRIPTION - Configurações melhoradas
      description = {
        position = "left", -- ou "right", "top", "bottom"
        width = "45%",     -- Aumentado para melhor leitura
        show_stats = true,
      },

      -- 🆕 PICKER - Configuração explícita
      picker = {
        provider = "telescope", -- força uso do telescope
      },

      -- 🆕 INJECTOR - Configurações expandidas
      injector = {
        ["rust"] = {
          before = {
            "use std::collections::*;",
            "use std::cmp::{min, max};",
            "use std::io::{self, Write};",
            "// Common type aliases",
            "type Result<T> = std::result::Result<T, Box<dyn std::error::Error>>;",
          },
        },
        ["python3"] = {
          before = true, -- usa imports padrão do leetcode.nvim
        },
        ["python"] = {
          before = true, -- usa imports padrão do leetcode.nvim
        },
        ["golang"] = {
          before = {
            "import (",
            "    \"fmt\"",
            "    \"sort\"",
            "    \"math\"",
            "    \"strings\"",
            "    \"strconv\"",
            "    \"container/heap\"",
            ")",
            "",
            "// Helper functions",
            "func min(a, b int) int { if a < b { return a }; return b }",
            "func max(a, b int) int { if a > b { return a }; return b }",
          },
        },
        ["typescript"] = {
          before = {
            "// Common TypeScript utilities for LeetCode",
            "type TreeNode = {",
            "    val: number;",
            "    left: TreeNode | null;",
            "    right: TreeNode | null;",
            "};",
            "",
            "type ListNode = {",
            "    val: number;",
            "    next: ListNode | null;",
            "};",
          },
        },
        ["javascript"] = {
          before = {
            "// Common JavaScript utilities for LeetCode",
            "const TreeNode = function(val, left, right) {",
            "    this.val = (val===undefined ? 0 : val);",
            "    this.left = (left===undefined ? null : left);",
            "    this.right = (right===undefined ? null : right);",
            "};",
            "",
            "const ListNode = function(val, next) {",
            "    this.val = (val===undefined ? 0 : val);",
            "    this.next = (next===undefined ? null : next);",
            "};",
          },
        },
        ["cpp"] = {
          before = {
            "#include <bits/stdc++.h>",
            "using namespace std;",
            "",
            "// Common type definitions",
            "typedef long long ll;",
            "typedef vector<int> vi;",
            "typedef vector<vector<int>> vvi;",
            "",
            "// Helper macros",
            "#define all(x) (x).begin(), (x).end()",
            "#define sz(x) (int)(x).size()",
          },
        },
        ["java"] = {
          before = {
            "import java.util.*;",
            "import java.util.stream.*;",
            "",
            "// Common definitions",
            "class TreeNode {",
            "    int val;",
            "    TreeNode left;",
            "    TreeNode right;",
            "    TreeNode() {}",
            "    TreeNode(int val) { this.val = val; }",
            "    TreeNode(int val, TreeNode left, TreeNode right) {",
            "        this.val = val;",
            "        this.left = left;",
            "        this.right = right;",
            "    }",
            "}",
            "",
            "class ListNode {",
            "    int val;",
            "    ListNode next;",
            "    ListNode() {}",
            "    ListNode(int val) { this.val = val; }",
            "    ListNode(int val, ListNode next) { this.val = val; this.next = next; }",
            "}",
          },
        },
      },

      -- 🆕 HOOKS - Hooks expandidos
      hooks = {
        ["enter"] = {
          function()
            vim.notify("🚀 LeetCode session started!", vim.log.levels.INFO)
            -- Configurar algumas opções específicas para LeetCode
            vim.opt.wrap = false
            vim.opt.number = true
            vim.opt.relativenumber = true
          end,
        },

        ["question_enter"] = {
          function(question)
            local ok, config = pcall(require, "leetcode.config")
            local current_lang = ok and config.lang or "unknown"

            vim.notify(
              string.format("📝 Opened: %s [%s] - Difficulty: %s",
                question.title,
                current_lang,
                question.difficulty or "Unknown"
              ),
              vim.log.levels.INFO
            )

            -- Auto-salvar quando mudar de pergunta
            vim.cmd("silent! wall")
          end,
        },

        ["leave"] = {
          function()
            vim.notify("👋 LeetCode session ended!", vim.log.levels.INFO)
            -- Restaurar opções originais
            vim.opt.wrap = true
          end,
        },
      },

      -- 🆕 KEYS - Configurações de teclas expandidas
      keys = {
        toggle = { "q", "<Esc>" },       -- Multiple keys para fechar
        confirm = { "<CR>", "<Space>" }, -- Multiple keys para confirmar
        reset_testcases = "r",
        use_testcase = "U",
        focus_testcases = "H",
        focus_result = "L",
      },

      -- 🆕 THEME - Tema customizado aprimorado
      theme = {
        -- Cores principais
        ["alt"] = {
          bg = "#1e1e2e", -- catppuccin mocha base
        },
        ["normal"] = {
          fg = "#cdd6f4", -- catppuccin mocha text
        },

        -- Cores de dificuldade
        ["easy"] = {
          fg = "#a6e3a1", -- green
          bold = true,
        },
        ["medium"] = {
          fg = "#fab387", -- orange
          bold = true,
        },
        ["hard"] = {
          fg = "#f38ba8", -- red
          bold = true,
        },

        -- Estados de problemas
        ["solved"] = {
          fg = "#a6e3a1", -- green
          italic = true,
        },
        ["attempted"] = {
          fg = "#f9e2af", -- yellow
        },
        ["not_started"] = {
          fg = "#6c7086", -- surface2
        },

        -- UI elements
        ["header"] = {
          fg = "#89b4fa", -- blue
          bold = true,
        },
        ["selected"] = {
          bg = "#313244", -- surface0
          fg = "#cdd6f4", -- text
        },
      },

      image_support = false, -- Mantido false para melhor performance
    },

    config = function(_, opts)
      local ok, leetcode = pcall(require, "leetcode")
      if not ok then
        vim.notify("❌ Failed to load leetcode.nvim", vim.log.levels.ERROR)
        return
      end

      leetcode.setup(opts)

      -- 🆕 KEYMAPS PRINCIPAIS - Organizados por categoria

      -- === MENU & NAVEGAÇÃO ===
      vim.keymap.set("n", "<leader>lq", "<cmd>Leet<cr>", { desc = "🏠 LeetCode Menu" })
      vim.keymap.set("n", "<leader>ll", "<cmd>Leet list<cr>", { desc = "📋 Problems List" })
      vim.keymap.set("n", "<leader>lt", "<cmd>Leet tabs<cr>", { desc = "📑 Tabs" })
      vim.keymap.set("n", "<leader>lx", "<cmd>Leet exit<cr>", { desc = "❌ Exit LeetCode" })

      -- === EXECUÇÃO DE CÓDIGO ===
      vim.keymap.set("n", "<leader>lr", "<cmd>Leet run<cr>", { desc = "▶️  Run Code" })
      vim.keymap.set("n", "<leader>ls", "<cmd>Leet submit<cr>", { desc = "🚀 Submit Solution" })
      vim.keymap.set("n", "<leader>lT", "<cmd>Leet test<cr>", { desc = "🧪 Test Code" })

      -- === PROBLEMAS ESPECIAIS ===
      vim.keymap.set("n", "<leader>ld", "<cmd>Leet daily<cr>", { desc = "📅 Daily Challenge" })
      vim.keymap.set("n", "<leader>lR", "<cmd>Leet random<cr>", { desc = "🎲 Random Problem" })

      -- === CONSOLE & INFO ===
      vim.keymap.set("n", "<leader>lc", "<cmd>Leet console<cr>", { desc = "🖥️  Console" })
      vim.keymap.set("n", "<leader>li", "<cmd>Leet info<cr>", { desc = "ℹ️  Problem Info" })
      vim.keymap.set("n", "<leader>ly", "<cmd>Leet yank<cr>", { desc = "📋 Yank Solution" })

      -- === GERENCIAMENTO DE LINGUAGENS ===
      vim.keymap.set("n", "<leader>lg", "<cmd>Leet lang<cr>", { desc = "🔧 Change Language" })

      -- Quick language switching com feedback visual
      vim.keymap.set("n", "<leader>l1", function()
        vim.cmd("Leet lang rust")
        vim.notify("🦀 Switched to Rust", vim.log.levels.INFO)
      end, { desc = "🦀 Switch to Rust" })

      vim.keymap.set("n", "<leader>l2", function()
        vim.cmd("Leet lang golang")
        vim.notify("🐹 Switched to Go", vim.log.levels.INFO)
      end, { desc = "🐹 Switch to Go" })

      vim.keymap.set("n", "<leader>l3", function()
        vim.cmd("Leet lang python3")
        vim.notify("🐍 Switched to Python3", vim.log.levels.INFO)
      end, { desc = "🐍 Switch to Python3" })

      vim.keymap.set("n", "<leader>l4", function()
        vim.cmd("Leet lang typescript")
        vim.notify("📘 Switched to TypeScript", vim.log.levels.INFO)
      end, { desc = "📘 Switch to TypeScript" })

      vim.keymap.set("n", "<leader>l5", function()
        vim.cmd("Leet lang cpp")
        vim.notify("⚡ Switched to C++", vim.log.levels.INFO)
      end, { desc = "⚡ Switch to C++" })

      vim.keymap.set("n", "<leader>l6", function()
        vim.cmd("Leet lang java")
        vim.notify("☕ Switched to Java", vim.log.levels.INFO)
      end, { desc = "☕ Switch to Java" })

      -- === UTILITIES ===
      vim.keymap.set("n", "<leader>lre", "<cmd>Leet reset<cr>", { desc = "🔄 Reset Code" })
      vim.keymap.set("n", "<leader>lo", "<cmd>Leet open<cr>", { desc = "🌐 Open in Browser" })
      vim.keymap.set("n", "<leader>lI", "<cmd>Leet inject<cr>", { desc = "💉 Re-inject Code" })
      vim.keymap.set("n", "<leader>lL", "<cmd>Leet last_submit<cr>", { desc = "📜 Last Submit" })
      vim.keymap.set("n", "<leader>lR", "<cmd>Leet restore<cr>", { desc = "🔧 Restore Layout" })

      -- === DESCRIPTION & STATS ===
      vim.keymap.set("n", "<leader>lD", "<cmd>Leet desc<cr>", { desc = "📖 Toggle Description" })
      vim.keymap.set("n", "<leader>lS", "<cmd>Leet stats<cr>", { desc = "📊 Toggle Stats" })
      vim.keymap.set("n", "<leader>ldt", "<cmd>Leet desc toggle<cr>", { desc = "📖 Toggle Description" })

      -- === SESSION MANAGEMENT ===
      vim.keymap.set("n", "<leader>lsc", "<cmd>Leet session create<cr>", { desc = "➕ Create Session" })
      vim.keymap.set("n", "<leader>lsh", "<cmd>Leet session change<cr>", { desc = "🔄 Change Session" })
      vim.keymap.set("n", "<leader>lsu", "<cmd>Leet session update<cr>", { desc = "🔄 Update Session" })

      -- === CACHE & COOKIE MANAGEMENT ===
      vim.keymap.set("n", "<leader>lcu", "<cmd>Leet cache update<cr>", { desc = "🔄 Update Cache" })
      vim.keymap.set("n", "<leader>lcou", "<cmd>Leet cookie update<cr>", { desc = "🍪 Update Cookie" })
      vim.keymap.set("n", "<leader>lcod", "<cmd>Leet cookie delete<cr>", { desc = "🚪 Sign Out" })

      -- === LIST WITH FILTERS ===
      vim.keymap.set("n", "<leader>lle", function()
        vim.cmd("Leet list difficulty=easy")
      end, { desc = "📋 Easy Problems" })

      vim.keymap.set("n", "<leader>llm", function()
        vim.cmd("Leet list difficulty=medium")
      end, { desc = "📋 Medium Problems" })

      vim.keymap.set("n", "<leader>llh", function()
        vim.cmd("Leet list difficulty=hard")
      end, { desc = "📋 Hard Problems" })

      vim.keymap.set("n", "<leader>lls", function()
        vim.cmd("Leet list status=solved")
      end, { desc = "✅ Solved Problems" })

      vim.keymap.set("n", "<leader>llt", function()
        vim.cmd("Leet list status=todo")
      end, { desc = "📝 Todo Problems" })

      vim.keymap.set("n", "<leader>lla", function()
        vim.cmd("Leet list status=attempted")
      end, { desc = "🔄 Attempted Problems" })

      -- 🆕 RANDOM WITH FILTERS
      vim.keymap.set("n", "<leader>lre", function()
        vim.cmd("Leet random difficulty=easy")
      end, { desc = "🎲 Random Easy" })

      vim.keymap.set("n", "<leader>lrm", function()
        vim.cmd("Leet random difficulty=medium")
      end, { desc = "🎲 Random Medium" })

      vim.keymap.set("n", "<leader>lrh", function()
        vim.cmd("Leet random difficulty=hard")
      end, { desc = "🎲 Random Hard" })

      -- 🆕 AUTOCMDS - Comandos automáticos aprimorados
      local leetcode_group = vim.api.nvim_create_augroup("LeetCodeNvim", { clear = true })

      -- Auto-save quando sair de buffers do LeetCode
      vim.api.nvim_create_autocmd("BufWritePost", {
        group = leetcode_group,
        pattern = "*.rs,*.go,*.py,*.ts,*.js,*.cpp,*.java",
        callback = function()
          local buf_name = vim.api.nvim_buf_get_name(0)
          if string.match(buf_name, "leetcode") then
            vim.notify("💾 LeetCode solution saved!", vim.log.levels.INFO)
          end
        end,
      })

      -- Auto-configurar opções quando entrar em buffer do LeetCode
      vim.api.nvim_create_autocmd("BufEnter", {
        group = leetcode_group,
        pattern = "*leetcode*",
        callback = function()
          vim.opt_local.wrap = false
          vim.opt_local.number = true
          vim.opt_local.relativenumber = true
          vim.opt_local.colorcolumn = "80"
          vim.opt_local.textwidth = 80
        end,
      })

      -- Auto-backup de soluções
      vim.api.nvim_create_autocmd("BufWritePre", {
        group = leetcode_group,
        pattern = "*leetcode*",
        callback = function()
          local buf_name = vim.api.nvim_buf_get_name(0)
          if string.match(buf_name, "leetcode") then
            -- Criar backup da solução
            local backup_dir = vim.fn.stdpath("data") .. "/leetcode/backups"
            vim.fn.mkdir(backup_dir, "p")

            local timestamp = os.date("%Y%m%d_%H%M%S")
            local filename = vim.fn.fnamemodify(buf_name, ":t")
            local backup_file = backup_dir .. "/" .. filename .. "_" .. timestamp

            vim.cmd("silent! write " .. backup_file)
          end
        end,
      })

      vim.notify("✅ LeetCode.nvim loaded successfully!", vim.log.levels.INFO)
    end,
  }
}
