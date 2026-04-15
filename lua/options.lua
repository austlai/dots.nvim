-- Options --

vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.smartindent = false
vim.opt.cursorline = true
vim.opt.showmatch = true
vim.opt.colorcolumn = "150"
vim.opt.textwidth = 150
vim.opt.clipboard = "unnamedplus"
vim.opt.number = true
vim.opt.completeopt = { "menu", "menuone", "noselect" }
vim.opt.inccommand = 'split'

vim.o.winborder = 'single'

vim.g.mapleader = " "

-- disable netrw for NvimTree
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- testing options
vim.o.updatetime = 200
vim.o.virtualedit = "block"

-- Must be set before ftplugin files load (needed by treesitter-textobjects)
vim.g.no_plugin_maps = true
