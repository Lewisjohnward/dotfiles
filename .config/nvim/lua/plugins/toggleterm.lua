return {
	"akinsho/toggleterm.nvim",
	lazy = false,
	version = "*",
	config = true,
	keys = {
		vim.keymap.set("n", "<leader>t", ":ToggleTerm size=10 direction=float<CR>i", { silent = true }),
		vim.keymap.set("n", "<leader>jk", [[<C-\><C-n><cmd>wincmd h<cr>]], { silent = true }),
		vim.keymap.set("t", "<leader>jk", [[<C-\><C-n><cmd>wincmd h<cr>]], { silent = true }),
	},
}
