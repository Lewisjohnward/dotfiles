return {
	"NeogitOrg/neogit",
	dependencies = {
		"nvim-lua/plenary.nvim", -- required
		"nvim-telescope/telescope.nvim", -- optional
		"sindrets/diffview.nvim", -- optional
		"ibhagwan/fzf-lua", -- optional
	},
	config = function()
		require("neogit").setup({
			status = {
				recent_commit_count = 30,
			},
		})
	end,
	lazy = false,
	keys = {
		vim.keymap.set("n", "<leader>ng", ":Neogit kind=vsplit<CR>", { silent = true }),
	},
}
