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
