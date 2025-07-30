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

-- Claude Code Integration Mappings (using <leader>cl to avoid conflicts with Copilot Chat)
map("n", "<leader>clt", ":ClaudeCode<CR>", { desc = "Toggle Claude Code terminal", noremap = true, silent = true })
map("n", "<leader>clf", ":ClaudeCodeFocus<CR>", { desc = "Focus Claude Code terminal", noremap = true, silent = true })
map("n", "<leader>clo", ":ClaudeCodeOpen<CR>", { desc = "Open Claude Code terminal", noremap = true, silent = true })
map("n", "<leader>clq", ":ClaudeCodeClose<CR>", { desc = "Close Claude Code terminal", noremap = true, silent = true })

-- File/selection sending
map("n", "<leader>cls", ":ClaudeCodeSend<CR>",
  { desc = "Send current file/selection to Claude", noremap = true, silent = true })
map("v", "<leader>cls", ":ClaudeCodeSend<CR>",
  { desc = "Send visual selection to Claude", noremap = true, silent = true })
map("n", "<leader>cla", ":ClaudeCodeTreeAdd<CR>",
  { desc = "Add file from tree to Claude", noremap = true, silent = true })

-- Diff management
map("n", "<leader>clda", ":ClaudeCodeDiffAccept<CR>", { desc = "Accept Claude diff", noremap = true, silent = true })
map("n", "<leader>cldd", ":ClaudeCodeDiffDeny<CR>", { desc = "Deny Claude diff", noremap = true, silent = true })

-- Server management
map("n", "<leader>clss", ":ClaudeCodeStart<CR>", { desc = "Start Claude Code server", noremap = true, silent = true })
map("n", "<leader>clsx", ":ClaudeCodeStop<CR>", { desc = "Stop Claude Code server", noremap = true, silent = true })
map("n", "<leader>clsi", ":ClaudeCodeStatus<CR>", { desc = "Show Claude Code status", noremap = true, silent = true })

-- Model selection
map("n", "<leader>clm", ":ClaudeCodeSelectModel<CR>", { desc = "Select Claude model", noremap = true, silent = true })

-- Alternative terminal-based Claude Code (if using greggh/claude-code.nvim)
-- map("n", "<leader>clt", "<cmd>lua require('claude-code').toggle()<CR>", { desc = "Toggle Claude Code terminal", noremap = true, silent = true })
-- map("n", "<leader>cls", "<cmd>lua require('claude-code').start_session()<CR>", { desc = "Start Claude Code session", noremap = true, silent = true })

-- Direct Claude AI integration (if using IntoTheNull/claude.nvim)
-- map("n", "<leader>clq", "<cmd>lua require('claude').ask()<CR>", { desc = "Ask Claude", noremap = true, silent = true })
-- map("v", "<leader>clq", "<cmd>lua require('claude').ask_with_selection()<CR>", { desc = "Ask Claude with selection", noremap = true, silent = true })
