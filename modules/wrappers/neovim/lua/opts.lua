vim.wo.signcolumn = 'yes'
vim.wo.relativenumber = true
vim.wo.number = true

vim.o.cursorline = true
vim.o.showmode = false
vim.o.showtabline = 2

-- Indent
vim.o.smarttab = true
vim.o.expandtab = true
vim.o.smartindent = true
vim.o.autoindent = true
vim.o.tabstop = 4
vim.o.softtabstop = 4
vim.o.shiftwidth = 4

vim.opt.cpoptions:append('I')
vim.opt.inccommand = 'split'
vim.opt.swapfile = true
vim.opt.dir = '/tmp'
vim.opt.smartcase = true
vim.opt.laststatus = 3
vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.ignorecase = true
vim.opt.wrap = false
vim.opt.clipboard = "unnamedplus"
vim.opt.encoding = "utf-8"
vim.opt.hidden = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.updatetime = 300
vim.opt.termguicolors = true
vim.opt.mouse = "a"
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.scrolloff = 9
vim.opt.cursorline = true
vim.opt.scroll = 6
vim.opt.signcolumn = "yes"
vim.opt.pumheight = 16
vim.opt.winborder = "single"
vim.opt.langmap =
[[ФИСВУАПРШОЛДЬТЩЗЙКЫЕГМЦЧНЯ;ABCDEFGHIJKLMNOPQRSTUVWXYZ,фисвуапршолдьтщзйкыегмцчня;abcdefghijklmnopqrstuvwxyz]]

vim.g.mapleader = " "

vim.cmd.colorscheme("theme")
