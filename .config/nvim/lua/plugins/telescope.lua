local config = function()
	require("telescope").load_extension("projects")

	local telescope = require("telescope")
	local actions = require("telescope.actions")

	telescope.setup({
		defaults = {
			mappings = {
				i = {
					["<C-j>"] = "move_selection_next",
					["<C-k>"] = "move_selection_previous",
					["<C-u>"] = false,
					["jk"] = actions.close,
				},
			},
			layout_strategy = "flex",
			layout_config = {
				-- bottom_pane = {
				-- 	height = 25,
				-- 	preview_cutoff = 120,
				-- 	prompt_position = "top",
				-- },
				-- center = {
				-- 	height = 0.4,
				-- 	preview_cutoff = 40,
				-- 	prompt_position = "top",
				-- 	width = 0.5,
				-- },
				-- cursor = {
				-- 	height = 0.9,
				-- 	preview_cutoff = 40,
				-- 	width = 0.8,
				-- },
				horizontal = {
					height = 0.9,
					preview_cutoff = 120,
					prompt_position = "bottom",
					width = 0.8,
				},
				vertical = {
					height = 0.9,
					preview_cutoff = 40,
					prompt_position = "bottom",
					width = 0.8,
				},
			},
		},
		pickers = {
			find_files = {
				-- theme = "dropdown",
				previewer = false,
				hidden = true,
			},
			live_grep = {
				-- theme = "dropdown",
				previewer = false,
			},
			buffers = {
				theme = "dropdown",
				previewer = false,
				mappings = {
					i = {
						["x"] = actions.delete_buffer + actions.move_to_top,
					},
				},
			},
		},
	})
end

return {
	"nvim-telescope/telescope.nvim",
	tag = "0.1.3",
	lazy = false,
	dependencies = { "nvim-lua/plenary.nvim" },
	config = config,
	keys = {
		vim.keymap.set("n", "<leader>fk", ":Telescope keymaps<CR>", { silent = true }),
		vim.keymap.set("n", "<leader>fH", ":Telescope help_tags<CR>", { silent = true }),
		vim.keymap.set("n", "<leader>ff", ":Telescope find_files<CR>", { silent = true }),
		vim.keymap.set("n", "<leader>fa", ":Telescope <CR>", { silent = true }),
		vim.keymap.set("n", "<leader>fg", ":Telescope live_grep<CR>", { silent = true }),
		vim.keymap.set("n", "<leader>fG", ":Telescope git_files<CR>", { silent = true }),
		vim.keymap.set("n", "<leader>fc", ":Telescope current_buffer_fuzzy_find<CR>", { silent = true }),
		vim.keymap.set("n", "<leader>fb", ":Telescope buffers<CR>", { silent = true }),
		vim.keymap.set("n", "<leader>fp", ":Telescope projects<CR>", { silent = true }),
		vim.keymap.set("n", "<leader>fr", ":Telescope resume<CR>", { silent = true }),
		vim.keymap.set("n", "<leader>gr", ":Telescope lsp_references<CR>", { silent = true }),
		vim.keymap.set("n", "<leader>fr", ":Telescope registers<CR>", { silent = true }),
		vim.keymap.set("n", "<leader>;fc", ":Telescope commands<CR>", { silent = true }),
		vim.keymap.set("n", "<leader>;fh", ":Telescope command_history<CR>", { silent = true }),
		vim.keymap.set("n", "<leader>;ff", ":Telescope filetypes<CR>", { silent = true }),
		vim.keymap.set("n", "<leader>;fj", ":Telescope jumplist<CR>", { silent = true }),
		vim.keymap.set("n", "<leader>;fvo", ":Telescope vim_options<CR>", { silent = true }),
		vim.keymap.set("n", "<leader>;fm", ":Telescope man_pages<CR>", { silent = true }),
		vim.keymap.set("n", "<leader>;fo", ":Telescope oldfiles<CR>", { silent = true }),
		vim.keymap.set("n", "<leader>;fd", ":Telescope diagnostics<CR>", { silent = true }),

		vim.keymap.set(
			"n",
			"<leader>fhf",
			":lua require'telescope.builtin'.find_files({ cwd = '~', prompt_title = 'Search files from /HOME' })<CR>",
			{ silent = true }
		),
		vim.keymap.set(
			"n",
			"<leader>fhw",
			":lua require'telescope.builtin'.live_grep({ cwd = '~', prompt_title = 'Grep from /HOME' })<CR>",
			{ silent = true }
		),
	},
}
