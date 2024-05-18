local g = vim.g
local opt = vim.opt

-- Leader Key
g.mapleader = " "
g.maplocalleader = " "

-- Colors
opt.termguicolors = true

-- Config
opt.updatetime = 250
opt.timeoutlen = 300

-- Indentation
opt.autoindent = true
opt.backspace = {"indent", "eol", "start"}
opt.breakindent = true
opt.expandtab = true
opt.shiftwidth = 2
opt.smartindent = true
opt.smarttab = true
opt.softtabstop = 2
opt.tabstop = 2

-- UI
g.have_nerd_font = true
opt.cursorline = true
opt.inccommand = "split"
opt.number = true
opt.relativenumber = true
opt.scrolloff = 10
opt.title = true
opt.wrap = false
opt.mouse = "a"
opt.signcolumn = 'yes'

-- Clipboard
opt.clipboard = 'unnamedplus'

-- Searching
opt.hlsearch = true
opt.ignorecase = true
opt.smartcase = true
opt.path:append({"**"})
opt.wildignore:append({"*/node_modules/*", "*/.git/*", "*/.DS_Store"})

-- Backup
opt.undofile = true
opt.backup = false

-- Tabs
opt.splitbelow = true
opt.splitright = true
opt.splitkeep = "cursor"

-- Whitespaces
opt.list = true
opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }
