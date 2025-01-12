-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Requerimentos do plugin toggleterm
local toggleterm = require("toggleterm")
local Terminal = require("toggleterm.terminal").Terminal

-- Configurar tamanhos para os terminais
local horizontal_size = 15 -- Altura do terminal horizontal
local vertical_size = 50 -- Largura do terminal vertical
local float_size = 0.8 -- Proporção do terminal flutuante (80% da tela)

-- Terminal horizontal
local horizontal = Terminal:new({
  direction = "horizontal",
  hidden = true,
  size = horizontal_size,
})

-- Terminal vertical
local vertical = Terminal:new({
  direction = "vertical",
  hidden = true,
  size = vertical_size,
})

-- Terminal flutuante
local float = Terminal:new({
  direction = "float",
  hidden = true,
  float_opts = {
    border = "rounded", -- Estilo da borda (opções: "single", "double", "rounded", "none")
    width = math.floor(vim.o.columns * float_size),
    height = math.floor(vim.o.lines * float_size),
  },
})

-- Funções para alternar os terminais
local function toggle_horizontal()
  horizontal:toggle()
end

local function toggle_vertical()
  vertical:toggle()
end

local function toggle_float()
  float:toggle()
end

-- Mapear atalhos para alternar os terminais no modo normal
vim.keymap.set("n", "<M-h>", toggle_horizontal, { desc = "Toggle Horizontal Terminal" })
vim.keymap.set("n", "<M-v>", toggle_vertical, { desc = "Toggle Vertical Terminal" })
vim.keymap.set("n", "<M-i>", toggle_float, { desc = "Toggle Floating Terminal" })

-- Mapear atalhos para alternar os terminais dentro do modo terminal
vim.keymap.set(
  "t",
  "<M-h>",
  [[<C-\><C-n>:lua require('toggleterm.terminal').Terminal:new({direction="horizontal"}):toggle()<CR>]],
  { desc = "Toggle Horizontal Terminal in Terminal Mode" }
)
vim.keymap.set(
  "t",
  "<M-v>",
  [[<C-\><C-n>:lua require('toggleterm.terminal').Terminal:new({direction="vertical"}):toggle()<CR>]],
  { desc = "Toggle Vertical Terminal in Terminal Mode" }
)
vim.keymap.set(
  "t",
  "<M-i>",
  [[<C-\><C-n>:lua require('toggleterm.terminal').Terminal:new({direction="float"}):toggle()<CR>]],
  { desc = "Toggle Floating Terminal in Terminal Mode" }
)

-- Mapeamento para sair do modo terminal com Ctrl+w
vim.api.nvim_create_autocmd("TermOpen", {
  pattern = "*",
  callback = function()
    vim.api.nvim_buf_set_keymap(0, "t", "<C-n>", [[<C-\><C-n>]], { noremap = true, silent = true })
  end,
})
