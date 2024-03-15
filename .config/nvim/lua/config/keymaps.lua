--local keymap = vim.keymap
--
-- Set highlight on search
vim.keymap.set("n", "<space>hh", ":noh<cr>", { silent = true })
-- Keymaps for better default experience
vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })
vim.keymap.set("n", "H", "^", { silent = true })
vim.keymap.set("n", "L", "$", { silent = true })
-- Remap for dealing with word wrap
vim.keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- set cursor line
vim.o.cursorline = true
-- Make line numbers default
vim.wo.number = true

-- Enable mouse mode
vim.o.mouse = "a"

-- Sync clipboard between OS and Neovim.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.o.clipboard = "unnamedplus"

-- Enable break indent
vim.o.breakindent = true

-- Save undo history
vim.o.undofile = true

-- Case-insensitive searching UNLESS \C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Keep signcolumn on by default
vim.wo.signcolumn = "yes"

-- Decrease update time
vim.o.updatetime = 250
vim.o.timeoutlen = 300

-- Set completeopt to have a better completion experience
vim.o.completeopt = "menuone,noselect"

-- NOTE: You should make sure your terminal supports this
vim.o.termguicolors = true

-- [[ Basic Keymaps ]]

-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup("YankHighlight", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
	callback = function()
		vim.highlight.on_yank()
	end,
	group = highlight_group,
	pattern = "*",
})

vim.opt.relativenumber = true
--vim.api.nvim_set_hl(0, 'LineNr', { fg = "white"})

-- nvim-tree
-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- save
vim.keymap.set("n", "<space><space>", ":w<cr>", { silent = true, desc = "Save current focused buffer" })
-- quit
vim.keymap.set("n", "<space>a;", ":q<cr>:q<cr>:q<cr>:q<cr>")
vim.keymap.set("n", "<space>q", ":q!<cr>", { silent = true })
-- edit rc
vim.keymap.set("n", "<space>rce", ":e $MYVIMRC<cr>", { silent = true })
-- re-source
vim.keymap.set("n", "<space>rcu", ":source $MYVIMRC<cr>", { silent = true })

-- navigate buffers
vim.keymap.set("n", "<tab>", ":bnext<cr>", { silent = true })
vim.keymap.set("n", "<s-tab>", ":bprev<cr>", { silent = true })

-- scroll
--vim.keymap.set('n', '<c-u>', '<c-u>zz')
-- vim.keymap.set('n', '<c-d>', '<c-d>zz')

-- close buffer
-- buffer previous| split| buffer next| buffer delete
vim.keymap.set("n", "<space>bcc", ":bp<bar>sp<bar>bn<bar>bd<CR>", { silent = true })
-- if buffer has unsaved changes force close
-- vim.keymap.set('n', '<c-x>x', ':bd!<CR>')

vim.keymap.set("i", "jk", "<esc>")
-- vim.keymap.set("v", "jk", "<esc>")
-- vim.keymap.set("x", "jk", "<esc>")

-- Window maps
vim.keymap.set("n", "<c-h>", "<c-w>h")
vim.keymap.set("n", "<c-j>", "<c-w>j")
vim.keymap.set("n", "<c-k>", "<c-w>k")
vim.keymap.set("n", "<c-l>", "<c-w>l")
vim.keymap.set("n", "<space>vw", "<c-w>v")
vim.keymap.set("n", "<space>hw", "<c-w>s")
vim.keymap.set("n", "<space>cw", "<c-w>c", { desc = "Close current focused window" })

-- open terminal
vim.keymap.set("n", "<space>sl", ":rightb vsplit term://bash<cr>")

-- Telescope
--leader sf -- search files
--:telescope keymaps
vim.keymap.set("n", "<space>sk", ":Telescope keymaps<cr>")

-- NvimTree
vim.keymap.set("n", "<c-n>", ":NvimTreeFocus<cr>", { silent = true })
vim.keymap.set("n", "<space>cn", ":NvimTreeClose<cr>", { silent = true })
--vim.keymap.set('n', '<c-n>', ':NvimTreeFindFileToggle!<cr>', { silent = true })
-- nvimtreeopen
-- nvimtreeclose
-- NvimTreeToggle
-- nvimtreerefresh
-- nvimtreefindfile
-- nvimtreefindfiletoggle
-- nvimtreecollapse
-- nvimtreecollapsekeepbuffers

-- Disable comments when hitting o or O
vim.o.formatoptions = "cro"

-- buffer previous| split| buffer next| buffer delete
vim.keymap.set("n", "<space>bcc", ":bp<bar>sp<bar>bn<bar>bd<CR>")
-- if buffer has unsaved changes force close
-- vim.keymap.set('n', '<c-x>x', ':bd!<CR>')

-- vim.keymap.set("n", "jk", "<esc>")

-- Window maps
vim.keymap.set("n", "<c-h>", "<c-w>h")
vim.keymap.set("n", "<c-j>", "<c-w>j")
vim.keymap.set("n", "<c-k>", "<c-w>k")
vim.keymap.set("n", "<c-l>", "<c-w>l")
vim.keymap.set("n", "<space>vw", "<c-w>v")
vim.keymap.set("n", "<space>cw", "<c-w>c")

-- open terminal
vim.keymap.set("n", "<space>sl", ":rightb vsplit term://bash<cr>")

-- Telescope
--leader sf -- search files
--:telescope keymaps
vim.keymap.set("n", "<space>sk", ":Telescope keymaps<cr>")

-- NvimTree
vim.keymap.set("n", "<c-n>", ":NvimTreeFindFile<cr>", { silent = true })
vim.keymap.set("n", "<space>cn", ":NvimTreeClose<cr>", { silent = true })
--vim.keymap.set('n', '<c-n>', ':NvimTreeFindFileToggle!<cr>', { silent = true })
-- nvimtreeopen
-- nvimtreeclose
-- NvimTreeToggle
-- nvimtreerefresh
-- nvimtreefindfile
-- nvimtreefindfiletoggle
-- nvimtreecollapse
-- nvimtreecollapsekeepbuffers

-- Disable comments when hitting o or O
vim.o.formatoptions = "cro"

-- indenting
vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", ">", ">gv")

-- comments
vim.api.nvim_set_keymap("n", "<c-_>", "gcc", { noremap = false })
vim.api.nvim_set_keymap("v", "<c-_>", "gc", { noremap = false })

-- fterm--
-- vim.api.nvim_create_user_command('FTermOpen', require('FTerm').open, { bang = true })

-- change dir
vim.keymap.set("n", "<leader>cd", ":cd %:p:h<cr>:pwd<cr>", { desc = "Set cwd to current files dir" })
vim.keymap.set("n", "<leader>l", ":ls<cr>:b<space>")

-- map <leader>log yiwoconsole.log(<ESC>pa)<ESC>:w<CR>
vim.keymap.set("n", "<leader>;cl", "yiwoconsole.log(<esc>pa)<esc>", { desc = "[C]onsole [L]og" })
vim.keymap.set("n", "<leader>cr", "@:", { desc = "[R]epeat [C]ommand" })

vim.keymap.set("v", "<leader>ca", ":Lspsaga code_action")

-- Primeagen
-- next greatest remap ever : asbjornHaland
-- vim.keymap.set({"n", "v"}, "<leader>y", [["+y]])
-- vim.keymap.set("n", "<leader>Y", [["+Y]])
--
-- vim.keymap.set({"n", "v"}, "<leader>d", [["_d]])
--
--
--
-- Move text up and down
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { silent = true })
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { silent = true })

-- Greatest
vim.keymap.set("x", "p", [["_dP]])
vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])

-- Undotree
vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle)

vim.keymap.set("n", "J", "mzJ`z")
-- vim.keymap.set("n", "K", ":m '>-2<CR>gv=gv")

-- insert clsx
-- vim.keymap.set("n", "<leader>clsx", 'f"i{clsx(jkf"f"a)}jkFc,;;jkjk')
-- expand tag
--ea
--jkO
