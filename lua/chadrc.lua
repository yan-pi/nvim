-- This file needs to have same structure as nvconfig.lua
-- https://github.com/NvChad/ui/blob/v3.0/lua/nvconfig.lua
-- Please read that file to know all available options :(

---@class M
---@field base46 table
---@field ui table
---@field nvdash table
---@field mason table
---@field lsp table
---@field colorify table
local M = {}

M.base46 = {
  theme = "chocolate",

  hl_override = {
    Comment = { italic = true },
    ["@comment"] = { italic = true },
    ["@lsp.type.comment"] = { italic = true },
    ["@lsp.typemod.comment"] = { italic = true },
    ["@lsp.typemod.function.defaultLibrary"] = { italic = true, bold = true },
    ["@lsp.typemod.variable.defaultLibrary"] = { italic = true, bold = true },
    ["@lsp.typemod.variable.readonly"] = { italic = true, bold = true },
    ["@lsp.typemod.variable.defaultLibrary.readonly"] = { italic = true, bold = true },
  },
}

M.ui = {
  cmp = {
    lspkind_text = true,
    style = "default", -- default/flat_light/flat_dark/atom/atom_colored
    format_colors = {
      -- lsp = true,      -- lsp colorscheme
      icon = "󱓻",
      tailwind = true,
    },
  },

  telescope = { style = "bordered" }, -- borderless / bordered

  statusline = {
    theme = "vscode_colored", -- default/vscode/vscode_colored/minimal
    -- default/round/block/arrow separators work only for default statusline theme
    -- round and block will work for minimal theme only
    separator_style = "default", -- default/round/block/arrow
    order = nil,
    modules = nil,
  },

  tabufline = {
    enabled = true,
    lazyload = true,
    order = { "treeOffset", "buffers", "tabs", "btns" },
    modules = nil,
    bufwidth = 21,
  },
}

M.nvdash = {
  load_on_startup = true,

  header = {
    "▪   ▐ ▄ ·▄▄▄▄  ▪   ▄▄▄·  ▐ ▄ ▄▄▄▄·        ▄· ▄▌",
    "██ •█▌▐███· ██ ██ ▐█ ▀█ •█▌▐█▐█ ▀█▪ ▄█▀▄ ▐█▪██▌",
    "▐█·▐█▐▐▌▐█▪ ▐█▌▐█·▄█▀▀█ ▐█▐▐▌▐█▀▀█▄▐█▌.▐▌▐█▌▐█▪",
    "▐█▌██▐█▌██. ██ ▐█▌▐█▪ ▐▌██▐█▌██▄▪▐█▐█▌.▐▌ ▐█▀·.",
    "▀▀▀▀▀ █▪▀▀▀▀▀• ▀▀▀ ▀  ▀ ▀▀ █▪·▀▀▀▀  ▀█▄▀▪  ▀ • ",
    "                             bubu lover        ",
    "                                               ",
    "     Powered By  eovim    ",
  },

  buttons = {
    { txt = "  Find File", keys = "Spc f f", cmd = "Telescope find_files" },
    { txt = "  Recent Files", keys = "Spc f o", cmd = "Telescope oldfiles" },
    { txt = "  Find Word", keys = "Spc f w", cmd = "Telescope live_grep" },
    { txt = "  Update Plugins", keys = "Spc l u", cmd = "Lazy sync" },
    { txt = "  Quit", keys = "Spc q a", cmd = "qa" },
    {
      txt = function()
        local stats = require("lazy").stats()
        local ms = math.floor(stats.startuptime) .. " ms"
        return "  Loaded " .. stats.loaded .. "/" .. stats.count .. " plugins in " .. ms
      end,
      hl = "NvDashFooter",
      no_gap = true,
    },

    { txt = "─", hl = "NvDashFooter", no_gap = true, rep = true },
  },
}

M.term = {
  base46_colors = true,
  winopts = { number = false, relativenumber = false },
  sizes = { sp = 0.3, vsp = 0.2, ["bo sp"] = 0.3, ["bo vsp"] = 0.2 },
  float = {
    relative = "editor",
    row = 0.3,
    col = 0.25,
    width = 0.5,
    height = 0.4,
    border = "single",
  },
}

M.mason = { pkgs = {}, skip = {} }

M.lsp = { signature = true }

M.cheatsheet = {
  theme = "grid",
}

M.colorify = {
  enabled = true,
  mode = "virtual", -- fg, bg, virtual
  virt_text = "󱓻 ",
  highlight = { hex = true, lspvars = true },
}

return M
