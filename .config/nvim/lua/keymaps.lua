-- prevent comments when pressing o for new line
vim.api.nvim_create_autocmd("FileType", {
  pattern = "*",
  callback = function()
    -- remove 'c', 'r', 'o' from formatoptions
    vim.opt_local.formatoptions:remove { "c", "r", "o" }
  end,
})

vim.api.nvim_set_keymap("n", "<C-n>", ":Neotree toggle<CR>", { noremap = true, silent = true })

vim.api.nvim_set_keymap("n", "<space>rcu", ":source<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap(
  "n",
  "<space>rce",
  ":e ~/.config/nvim/lua/lazy_setup.lua<CR>",
  { noremap = true, silent = true }
)
vim.api.nvim_set_keymap("n", "<space><space>", ":w<CR>", { noremap = true, silent = true })

vim.api.nvim_set_keymap("n", "<space>gh", ":q<CR>:q<CR>", { noremap = true, silent = true })

vim.api.nvim_set_keymap(
  "n",
  "<space>v",
  ":vsplit<CR>",
  { noremap = true, silent = true, desc = "Split window vertically" }
)
vim.api.nvim_set_keymap(
  "n",
  "<space>h",
  ":split<CR>",
  { noremap = true, silent = true, desc = "Slit window horizontally" }
)
vim.api.nvim_set_keymap("n", "<space>q", ":close<CR>", { noremap = true, silent = true, desc = "Close window" })

-- Remap for dealing with word wrap
vim.keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Keymaps for better default experience
vim.keymap.set("n", "H", "^", { silent = true })
vim.keymap.set("n", "L", "$", { silent = true })

-- Move text up and down
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { silent = true })
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { silent = true })

-- Key cursor in place when moving following line up
vim.keymap.set("n", "J", "mzJ`z")

-- Point Neotree at current dir
vim.api.nvim_set_keymap("n", "<leader>e", ":Neotree reveal dir=./<CR>", { noremap = true, silent = true })

-- Prevent overwriting sys clipboard when deleting textjo
-- vim.keymap.set("n", "dd", '"_dd', { noremap = true, silent = true })
-- vim.keymap.set("n", "d", '"_d', { noremap = true, silent = true })
-- vim.keymap.set("n", "c", '"_c', { noremap = true, silent = true })
--
-- -- Map delete in visual mode to use the black hole register
-- vim.keymap.set("v", "d", '"_d', { noremap = true, silent = true })
--
-- -- map 'c' to use the black hole register in normal mode
-- vim.keymap.set("n", "c", '"_c', { noremap = true, silent = true })
--
-- vim.keymap.set("v", "c", '"_c', { noremap = true, silent = true })
-- Map 'c' to use the black hole register in visual mode

--
-- vim.api.nvim_set_keymap(
--   "n",
--   "<leader><f2>",
--   "<cmd>lua require('telescope.builtin').grep_string({search = vim.fn.expand(\"<cword>\")})<cr>",
--   {}
-- )

vim.keymap.set("n", "<leader><", ":vertical resize -10<CR>")
vim.keymap.set("n", "<leader>>", ":vertical resize +10<CR>")

vim.api.nvim_set_keymap(
  "n",
  "<leader>sd",
  [[<cmd>lua require('telescope.builtin').grep_string()<cr>]],
  { silent = true, noremap = true, desc = "Find occurence of hovered word in project" }
)

vim.opt.wrap = true

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.writebackup = false

-- Load file navigation utilities
local file_nav = require("utils.file_navigation")
local productivity = require("utils.productivity")

-- Open or create test file for current file
vim.keymap.set("n", "<leader>ot", file_nav.open_test_file, { noremap = true, silent = true, desc = "Open or create test file" })

-- Open or create Storybook story file for current file
vim.keymap.set("n", "<leader>os", file_nav.open_story_file, { noremap = true, silent = true, desc = "Open or create Storybook story file" })

-- Productivity keymaps
vim.keymap.set("n", "<leader>pt", productivity.run_test, { noremap = true, silent = true, desc = "Run test for current file" })
vim.keymap.set("n", "<leader>it", productivity.insert_todo, { noremap = true, silent = true, desc = "Insert TODO comment" })
vim.keymap.set("n", "<leader>il", productivity.insert_console_log, { noremap = true, silent = true, desc = "Insert console.log" })
vim.keymap.set("v", "<leader>il", productivity.insert_console_log, { noremap = true, silent = true, desc = "Insert console.log" })
vim.keymap.set("n", "<leader>iL", productivity.fuzzy_console_log, { noremap = true, silent = true, desc = "Fuzzy find variable to log" })

-- Jump list navigation
vim.keymap.set("n", "<leader>j", "<C-o>", { noremap = true, silent = true, desc = "Go back in jump list" })
vim.keymap.set("n", "<leader>k", "<C-i>", { noremap = true, silent = true, desc = "Go forward in jump list" })
