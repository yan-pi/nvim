require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

local opts = { noremap = true, silent = true }

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

map("i", "<C-Enter>", function()
  vim.fn.feedkeys(vim.fn["copilot#Accept"](), "")
end, { desc = "Copilot Accept", noremap = true, silent = true })
-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")

map(
  "n",
  "<leader>d",
  "<cmd>lua vim.diagnostic.open_float()<CR>",
  { desc = "Open diagnostic float", noremap = true, silent = true }
)

map("n", "<leader>ty", ":tabnew<CR>", { noremap = true, silent = true })      -- New Tab
map("n", "<leader>tc", ":tabclose<CR>", { noremap = true, silent = true })    -- Close Tab
map("n", "<leader>to", ":tabonly<CR>", { noremap = true, silent = true })     -- Close Other Tabs
map("n", "<leader>tp", ":tabprevious<CR>", { noremap = true, silent = true }) -- Previous Tab
map("n", "<leader>tn", ":tabnext<CR>", { noremap = true, silent = true })     -- Next Tab

-- Telescope Mappings
map("n", "<Space>fd", ":Telescope diagnostics<CR>", opts)

map("n", "<leader>ft", function()
  require("todo-comments")
  vim.cmd("TodoTelescope")
end, opts)

map('n', '<A-t>', ':FloatermToggle<CR>', { noremap = true, silent = true })
map('t', '<C-n>', '<C-\\><C-n>', { noremap = true, silent = true })

map("n", "<Space>ff", ":Telescope find_files<CR>", opts)
map("n", "<Space>fo", ":Telescope oldfiles<CR>", opts)
map("n", "<Space>fw", ":Telescope live_grep<CR>", opts)
map("n", "<Space>lu", ":Lazy sync<CR>", opts)
map("n", "<Space>qa", ":qa<CR>", opts)

-- Claude Code Integration Mappings (using <leader>cl to avoid copilot conflicts)
map("n", "<leader>clc", ":ClaudeCode<CR>", { desc = "Start Claude Code", noremap = true, silent = true })
map("n", "<leader>cla", ":ClaudeCodeAdd<CR>", { desc = "Add file to Claude Code", noremap = true, silent = true })
map("v", "<leader>cla", ":ClaudeCodeAdd<CR>", { desc = "Add selection to Claude Code", noremap = true, silent = true })
map("n", "<leader>clt", ":ClaudeCodeToggle<CR>", { desc = "Toggle Claude Code terminal", noremap = true, silent = true })
map("n", "<leader>clr", ":ClaudeCodeReload<CR>", { desc = "Reload Claude Code session", noremap = true, silent = true })

-- Alternative terminal-based Claude Code (if using greggh/claude-code.nvim)
-- map("n", "<leader>clt", "<cmd>lua require('claude-code').toggle()<CR>", { desc = "Toggle Claude Code terminal", noremap = true, silent = true })
-- map("n", "<leader>cls", "<cmd>lua require('claude-code').start_session()<CR>", { desc = "Start Claude Code session", noremap = true, silent = true })

-- Direct Claude AI integration (if using IntoTheNull/claude.nvim)
-- map("n", "<leader>clq", "<cmd>lua require('claude').ask()<CR>", { desc = "Ask Claude", noremap = true, silent = true })
-- map("v", "<leader>clq", "<cmd>lua require('claude').ask_with_selection()<CR>", { desc = "Ask Claude with selection", noremap = true, silent = true })
