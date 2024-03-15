local config = function()
	local theme = require("lualine.themes.tokyonight")

	-- set bg transparency in all modes

	require("lualine").setup({
		options = {
			theme = theme,
			-- theme = "tokyonight",
			globalstatus = true,
		},
		tabline = {
			lualine_a = { "buffers", "branch" },
			lualine_z = {
				function()
					local cwd = vim.fn.getcwd()
					return "cwd: " .. cwd
				end,
			},
			-- 	lualine_a = { "mode" },
			-- 	lualine_b = { "buffers" },
			-- 	lualine_x = { "encoding", "fileformat", "filetype" },
			-- 	lualine_y = { "progress" },
		},
		sections = {
			lualine_a = { "mode" },
			lualine_b = { "branch", "diff", "diagnostics" },
			lualine_c = {},
			lualine_x = { "encoding", "fileformat", "filetype" },
			lualine_y = { "progress" },
			lualine_z = { "location" },
		},
		-- sections = {
		-- 	lualine_a = { "mode" },
		-- 	lualine_b = { "branch", "diff", "diagnostics" },
		-- 	lualine_c = { "filename" },
		-- 	lualine_x = { "encoding", "fileformat", "filetype" },
		-- 	lualine_y = { "progress" },
		-- 	lualine_z = { "location" },
		-- },
		-- inactive_sections = {
		-- 	lualine_a = {},
		-- 	lualine_b = {},
		-- 	lualine_c = { "filename" },
		-- 	lualine_x = { "location" },
		-- 	lualine_y = {},
		-- 	lualine_z = {},
		-- },
		-- sections = {
		-- 	lualine_a = {
		-- 		{
		-- 			"buffers",
		-- 		},
		-- 	},
		-- },
	})
end

return {
	"nvim-lualine/lualine.nvim",
	lazy = false,
	config = config,
}
