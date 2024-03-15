local opt = vim.opt
-- set alls
-- options

-- remove comments on things
opt.formatoptions:remove({ "c", "r", "o" })
--
--opt.autochdir = true
-- Tab /indentation
opt.tabstop = 2
opt.shiftwidth = 2
opt.softtabstop = 2
opt.expandtab = true
opt.smartindent = true
opt.wrap = true
opt.cursorline = true

-- Search
opt.incsearch = true
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = true

-- Appearance
opt.relativenumber = true
opt.termguicolors = true
-- opt.colorcolumn = '100'
opt.signcolumn = "yes"
opt.cmdheight = 1
opt.scrolloff = 4
opt.completeopt = "menuone,noinsert,noselect"

-- Behaviour
opt.hidden = true
opt.errorbells = true
opt.swapfile = false
opt.backup = false
opt.undodir = vim.fn.expand("~/.vim.undodir")
opt.undofile = true
opt.backspace = "indent,eol,start"
opt.splitright = true
opt.splitbelow = true
-- opt.autochdir = false
-- opt.iskeyword:append("-")
opt.mouse:append("a")
opt.clipboard:append("unnamedplus")
opt.modifiable = true
-- github opt.guicursor = "
opt.encoding = "UTF-8"

vim.g.nvim_tree_respect_buf_cwd = 1
