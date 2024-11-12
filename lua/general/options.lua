-- Options --

vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.smartindent = false
vim.opt.cursorline = true
vim.opt.showmatch = true
vim.opt.colorcolumn = "80"
vim.opt.clipboard = "unnamedplus"
vim.opt.mouse = "a"
vim.opt.number = true
vim.opt.completeopt = { "menu", "menuone", "noselect" }
vim.opt.termguicolors = true

vim.g.mapleader = " "

-- disable netrw for NvimTree
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
