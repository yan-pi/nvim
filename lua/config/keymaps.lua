-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
--
local function map(mode, lhs, rhs, opts)
  local keys = require("lazy.core.handler").handlers.keys
  ---@cast keys LazyKeysHandler
  -- do not create the keymap if a lazy keys handler exists
  if not keys.active[keys.parse({ lhs, mode = mode }).id] then
    opts = opts or {}
    opts.silent = opts.silent ~= false
    if opts.remap and not vim.g.vscode then
      opts.remap = nil
    end
    vim.keymap.set(mode, lhs, rhs, opts)
  end
end

-- Requerimentos do plugin toggleterm
local toggleterm = require("toggleterm")
local Terminal = require("toggleterm.terminal").Terminal

-- Configurações de terminais
local horizontal_size = 15
local vertical_size = 50
local float_size = 0.8

-- Criar instâncias de terminais
local horizontal = Terminal:new({
  direction = "horizontal",
  hidden = true,
  size = horizontal_size,
})

local vertical = Terminal:new({
  direction = "vertical",
  hidden = true,
  size = vertical_size,
})

local float = Terminal:new({
  direction = "float",
  hidden = true,
  float_opts = {
    border = "rounded",
    width = math.floor(vim.o.columns * float_size),
    height = math.floor(vim.o.lines * float_size),
  },
})

-- Funções de alternância dos terminais
local function toggle_horizontal()
  horizontal:toggle()
end

local function toggle_vertical()
  vertical:toggle()
end

local function toggle_float()
  float:toggle()
end

-- Mapeando teclas para alternar terminais no modo normal
map("n", "<C-x>", "<C-\\><C-N>", { desc = "Escape terminal mode" })
map("n", "<leader>h", toggle_horizontal, { desc = "Toggle Horizontal Terminal" })
map("n", "<leader>v", toggle_vertical, { desc = "Toggle Vertical Terminal" })
map("n", "<leader>i", toggle_float, { desc = "Toggle Floating Terminal" })

-- Alternância dos terminais no modo terminal
map({ "n", "t" }, "<A-v>", toggle_vertical, { desc = "Toggle Vertical Terminal" })
map({ "n", "t" }, "<A-h>", toggle_horizontal, { desc = "Toggle Horizontal Terminal" })
map({ "n", "t" }, "<A-i>", toggle_float, { desc = "Toggle Floating Terminal" })

-- Terminal novos no modo normal
map("n", "<leader>h", function()
  horizontal:toggle()
end, { desc = "Terminal new horizontal term" })

map("n", "<leader>v", function()
  vertical:toggle()
end, { desc = "Terminal new vertical term" })
-- Oil.nvim
map("n", "-", "<cmd>Oil<cr>", { desc = "Open oil.nvim" })
map("n", "<leader>-", function()
  require("oil").toggle_float()
end, { desc = "Open parent directory in floating window" })

-- Neo-tree
map("n", "<leader>E", "<cmd>Neotree toggle buffers<cr>", { desc = "Toggle Buffers Explorer" })

-- Telescope
map("n", "<C-p>", "<cmd>Telescope find_files<cr>")
map("n", "<leader>fw", "<cmd>Telescope live_grep<cr>")
map("n", "<leader>fa", "<cmd>Telescope live_grep_args<cr>")
map("n", "<leader>fx", "<cmd>Telescope find_files find_command=rg,--ignore,--hidden,--files,--glob=.env<cr>")

-- Tranparent
map("n", "<leader>uT", "<cmd>TransparentEnable<cr>", { desc = "Enable background transparency" })
map("n", "<leader>ut", "<cmd>TransparentToggle<cr>", { desc = "Toggle background transparency" })

-- mini.nvim
map("n", "<leader>C", function()
  require("mini.bufremove").delete(0, false)
end, { desc = "Delete Buffer" })

-- some utilities
map("n", "<leader>r", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { desc = "Search and Replace RegExp" })
map("n", "tn", "<cmd>tabnew<cr>")
map("n", "<leader>n", "<cmd>noh<cr>", { desc = "Remove highlighting of search matches" })

-- utilities to center the screen
map("n", "<C-d>", "<C-d>zz")
map("n", "<C-u>", "<C-u>zz")
map("n", "n", "nzzzv")
map("n", "N", "Nzzzv")

-- visual
map("v", "p", '"_dP')
map("v", "<", "<gv")
map("v", ">", ">gv")

-- moving lines
map("x", "J", ":m '>+1<cr>gv=gv")
map("x", "K", ":m '<-2<cr>gv=gv")

-- diagnostics
map(
  "n",
  "<leader>d",
  "<cmd>lua vim.diagnostic.open_float()<CR>",
  { desc = "Open diagnostic float", noremap = true, silent = true }
)
