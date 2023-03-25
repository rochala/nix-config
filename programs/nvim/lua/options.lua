local opt = vim.opt
local global_opt = vim.opt_global

local indent = 2

-- global
global_opt.shortmess:append("c")
global_opt.termguicolors = true
global_opt.hidden = true
global_opt.showtabline = 1
global_opt.updatetime = 300
global_opt.showmatch = true
global_opt.laststatus = 2
global_opt.wildignore = { ".git", "*/node_modules/*", "*/target/*", ".metals", ".bloop", ".ammonite", "community-build" }
global_opt.ignorecase = true
global_opt.smartcase = true
global_opt.clipboard = "unnamed"
global_opt.completeopt = { "menuone", "noinsert" }
global_opt.formatoptions = "cqrnj"
global_opt.scrolloff = 8
global_opt.lazyredraw = true
global_opt.undodir = "/Users/jrochala/.vim/undodir"
global_opt.undofile = true

opt.guicursor = ""
opt.showmatch = false
opt.relativenumber = true
opt.number = true

opt.breakindent = true
opt.linebreak = true
opt.joinspaces = false

-- window-scoped
opt.wrap = false
opt.cursorline = true
opt.signcolumn = "yes"
opt.colorcolumn = "120"
opt.mouse = "a"

-- buffer-scoped
opt.tabstop = indent
opt.shiftwidth = indent
opt.softtabstop = indent
opt.expandtab = true
opt.fileformat = "unix"

opt.foldlevelstart = 99
opt.foldmethod     = 'indent'

opt.termguicolors = true
opt.list = true

-- statusline
opt.statusline = "%!luaeval('Status_line()')"

vim.g.completion_matching_strategy_list = { 'exact', 'substring', 'fuzzy' }
vim.g.loaded_matchparen = 1
