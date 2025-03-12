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

map("n", "<leader>ty", ":tabnew<CR>", { noremap = true, silent = true }) -- New Tab
map("n", "<leader>tc", ":tabclose<CR>", { noremap = true, silent = true }) -- Close Tab
map("n", "<leader>to", ":tabonly<CR>", { noremap = true, silent = true }) -- Close Other Tabs
map("n", "<leader>tp", ":tabprevious<CR>", { noremap = true, silent = true }) -- Previous Tab
map("n", "<leader>tn", ":tabnext<CR>", { noremap = true, silent = true }) -- Next Tab

map("n", "<Space>fd", ":Telescope diagnostics<CR>", opts)

map("n", "<Space>ff", ":Telescope find_files<CR>", opts)
map("n", "<Space>fo", ":Telescope oldfiles<CR>", opts)
map("n", "<Space>fw", ":Telescope live_grep<CR>", opts)
map("n", "<Space>pb", ":Telescope projects<CR>", opts)
map("n", "<Space>lu", ":Lazy sync<CR>", opts)
map("n", "<Space>qa", ":qa<CR>", opts)
