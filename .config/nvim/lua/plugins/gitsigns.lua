return {
	"lewis6991/gitsigns.nvim",
	lazy = false,
	config = function()
		require("gitsigns").setup({
			signs = {
				add = { text = "+" },
				change = { text = "│" },
				delete = { text = "x" },
				topdelete = { text = "‾" },
				changedelete = { text = "~" },
				untracked = { text = "┆" },
			},
		})
	end,
}
