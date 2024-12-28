-- tabs
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true

-- visual
vim.opt.wrap = false
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.swapfile = false
vim.opt.scrolloff = 2
vim.opt.termguicolors = true

-- search
vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.ignorecase = true

-- misc
vim.opt.backup = false

-- always load last so that I don't lose basic settings
require("core.keymap")
require("core.plugins")
require("core.plugin_config")
