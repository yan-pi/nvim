-- This file needs to have same structure as nvconfig.lua
-- https://github.com/NvChad/ui/blob/v3.0/lua/nvconfig.lua
-- Please read that file to know all available options :(

---@type ChadrcConfig
local M = {}

M.base46 = {
  theme = "kanagawa",

  hl_override = {
    Comment = { italic = true },
    ["@comment"] = { italic = true },
  },
}

M.ui = {
  cmp = {
    lspkind_text = true,
    style = "default", -- default/flat_light/flat_dark/atom/atom_colored
    format_colors = {
      tailwind = true,
    },
  },

  telescope = { style = "bordered" }, -- borderless / bordered

  statusline = {
    theme = "vscode_colored", -- default/vscode/vscode_colored/minimal
    -- default/round/block/arrow separators work only for default statusline theme
    -- round and block will work for minimal theme only
    separator_style = "default",
    order = nil,
    modules = nil,
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
    -- { txt = "  Restore Session", keys = "Spc s r", cmd = "SessionManager load_session" },
    -- { txt = "  New File", keys = "Spc f n", cmd = "ene | startinsert" },
    { txt = "  Find Word", keys = "Spc f w", cmd = "Telescope live_grep" },
    { txt = "  Project Browser", keys = "Spc p b", cmd = "Telescope projects" },
    { txt = "  Update Plugins", keys = "Spc l u", cmd = "Lazy sync" },
    -- { txt = "  Open Settings", keys = "Spc e c", cmd = "edit $MYVIMRC" },
    { txt = "  Quit", keys = "Spc q a", cmd = "qa" },
  },
}

M.mason = { pkgs = {}, skip = {} }

M.lsp = { signature = true }

M.colorify = {
  enabled = true,
  mode = "virtual", -- fg, bg, virtual
  virt_text = "󱓻 ",
  highlight = { hex = true, lspvars = true },
}

return M
