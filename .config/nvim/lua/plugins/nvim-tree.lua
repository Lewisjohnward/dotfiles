--  local function my_on_attach(bufnr)
--    local api = require "nvim-tree.api"
--
--
--  	local function opts(desc)
--  		return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
--  	end
--  	--api.config.mappings.default_on_attach(bufnr)
--  	vim.keymap.set('n', 'u', api.tree.change_root_to_parent, opts('Up'))
--  	vim.keymap.set('n', '<C-]>', api.tree.change_root_to_node, opts('CD'))
--  	vim.keymap.set('n', 'r', api.fs.rename_full, opts('Rename: Full Path'))
--  end
--
--
--  return {
--      "nvim-tree/nvim-tree.lua",
--      lazy = false,
--  	dependencies = {
--  		"nvim-tree/nvim-web-devicons",
--  	},
--      filters = {
--          dotfiles = true,
--      },
--  	-- on_attach = my_on_attach(bufnr),
--   on_attach = function(bufnr)
--   local api = require("nvim-tree.api")
--
--  api.config.mappings.default_on_attach(bufnr)
--
--  vim.keymap.set("n", "<C-s>", api.node.open.horizontal, opts("Open: Horizontal Split"))
--  end,
--    keymaps = {
--      vim.keymap.set('n', '<c-n>', ':NvimTreeFindFile<cr>')
--    }
--  }
--
local M = {
	"nvim-tree/nvim-tree.lua",
	cmd = { "NvimTreeToggle", "NvimTreeFindFileToggle" },
}

M.init = function()
	vim.keymap.set("n", "<c-n>", ":NvimTreeFindFile<cr>", { silent = true })
	--vim.keymap.set("", "<leader>ee", "<Esc>:NvimTreeToggle<CR>", { silent = true })
	-- vim.keymap.set("", "<leader>ef", "<Esc>:NvimTreeFindFileToggle<CR>", { silent = true })
end

M.config = function()
	vim.cmd([[hi NvimTreeNormal guibg=NONE ctermbg=NONE]])
	require("nvim-tree").setup({
		disable_netrw = true,
		hijack_cursor = true,
		hijack_netrw = false,
		update_cwd = true,
		view = {
			width = 30,
			side = "left",
		},
		renderer = {
			indent_markers = {
				enable = true,
				icons = {
					corner = "└ ",
					edge = "│ ",
					none = "  ",
				},
			},
			icons = {
				symlink_arrow = " → ", -- ➜ → ➛
				show = {
					file = true,
					folder = true,
					folder_arrow = true,
					git = false,
				},
				glyphs = {
					git = {
						-- staged = "✓",
						-- renamed     = "➜",
						-- renamed     = "→",
						unstaged = "M",
						staged = "S",
						unmerged = "U",
						renamed = "R",
						untracked = "?",
						deleted = "✗",
						ignored = "◌",
					},
				},
			},
			special_files = {
				"README.md",
				"LICENSE",
				"Cargo.toml",
				"Makefile",
				"package.json",
				"package-lock.json",
				"go.mod",
				"go.sum",
			},
		},
		diagnostics = {
			enable = true,
			show_on_dirs = true,
			icons = {
				hint = "󰌵",
				info = "",
				warning = "",
				error = "",
			},
		},
		filters = {
			dotfiles = false,
			custom = {
				"\\.git",
				".cache",
				"node_modules",
				"__pycache__",
			},
		},
		git = {
			enable = true,
			ignore = false,
			timeout = 400,
		},
		actions = {
			use_system_clipboard = false,
			change_dir = {
				enable = false,
				global = false,
				restrict_above_cwd = false,
			},
			open_file = {
				quit_on_open = true,
				resize_window = true,
			},
		},
		-- https://github.com/nvim-tree/nvim-tree.lua/wiki/Migrating-To-on_attach
		on_attach = function(bufnr)
			local api = require("nvim-tree.api")

			local function opts(desc)
				return {
					desc = "nvim-tree: " .. desc,
					buffer = bufnr,
					noremap = true,
					silent = true,
					nowait = true,
					-- update_cwd = false,
				}
			end

			api.config.mappings.default_on_attach(bufnr)
			-- `<C-]>`           CD                         |nvim-tree-api.tree.change_root_to_node()|
			-- `<C-e>`           Open: In Place             |nvim-tree-api.node.open.replace_tree_buffer()|
			-- `<C-k>`           Info                       |nvim-tree-api.node.show_info_popup()|
			-- `<C-r>`           Rename: Omit Filename      |nvim-tree-api.fs.rename_sub()|
			-- `<C-t>`           Open: New Tab              |nvim-tree-api.node.open.tab()|
			-- `<C-v>`           Open: Vertical Split       |nvim-tree-api.node.open.vertical()|
			-- `<C-x>`           Open: Horizontal Split     |nvim-tree-api.node.open.horizontal()|
			-- `<BS>`            Close Directory            |nvim-tree-api.node.navigate.parent_close()|
			-- `<CR>`            Open                       |nvim-tree-api.node.open.edit()|
			-- `<Tab>`           Open Preview               |nvim-tree-api.node.open.preview()|
			-- `>`               Next Sibling               |nvim-tree-api.node.navigate.sibling.next()|
			-- `<`               Previous Sibling           |nvim-tree-api.node.navigate.sibling.prev()|
			-- `.`               Run Command                |nvim-tree-api.node.run.cmd()|
			-- `-`               Up                         |nvim-tree-api.tree.change_root_to_parent()|
			-- `a`               Create                     |nvim-tree-api.fs.create()|
			-- `bd`              Delete Bookmarked          |nvim-tree-api.marks.bulk.delete()|
			-- `bt`              Trash Bookmarked           |nvim-tree-api.marks.bulk.trash()|
			-- `bmv`             Move Bookmarked            |nvim-tree-api.marks.bulk.move()|
			-- `B`               Toggle Filter: No Buffer   |nvim-tree-api.tree.toggle_no_buffer_filter()|
			-- `c`               Copy                       |nvim-tree-api.fs.copy.node()|
			-- `C`               Toggle Filter: Git Clean   |nvim-tree-api.tree.toggle_git_clean_filter()|
			-- `[c`              Prev Git                   |nvim-tree-api.node.navigate.git.prev()|
			-- `]c`              Next Git                   |nvim-tree-api.node.navigate.git.next()|
			-- `d`               Delete                     |nvim-tree-api.fs.remove()|
			-- `D`               Trash                      |nvim-tree-api.fs.trash()|
			-- `E`               Expand All                 |nvim-tree-api.tree.expand_all()|
			-- `e`               Rename: Basename           |nvim-tree-api.fs.rename_basename()|
			-- `]e`              Next Diagnostic            |nvim-tree-api.node.navigate.diagnostics.next()|
			-- `[e`              Prev Diagnostic            |nvim-tree-api.node.navigate.diagnostics.prev()|
			-- `F`               Clean Filter               |nvim-tree-api.live_filter.clear()|
			-- `f`               Filter                     |nvim-tree-api.live_filter.start()|
			-- `g?`              Help                       |nvim-tree-api.tree.toggle_help()|
			-- `gy`              Copy Absolute Path         |nvim-tree-api.fs.copy.absolute_path()|
			-- `H`               Toggle Filter: Dotfiles    |nvim-tree-api.tree.toggle_hidden_filter()|
			-- `I`               Toggle Filter: Git Ignore  |nvim-tree-api.tree.toggle_gitignore_filter()|
			-- `J`               Last Sibling               |nvim-tree-api.node.navigate.sibling.last()|
			-- `K`               First Sibling              |nvim-tree-api.node.navigate.sibling.first()|
			-- `m`               Toggle Bookmark            |nvim-tree-api.marks.toggle()|
			-- `o`               Open                       |nvim-tree-api.node.open.edit()|
			-- `O`               Open: No Window Picker     |nvim-tree-api.node.open.no_window_picker()|
			-- `p`               Paste                      |nvim-tree-api.fs.paste()|
			-- `P`               Parent Directory           |nvim-tree-api.node.navigate.parent()|
			-- `q`               Close                      |nvim-tree-api.tree.close()|
			-- `r`               Rename                     |nvim-tree-api.fs.rename()|
			-- `R`               Refresh                    |nvim-tree-api.tree.reload()|
			-- `s`               Run System                 |nvim-tree-api.node.run.system()|
			-- `S`               Search                     |nvim-tree-api.tree.search_node()|
			-- `u`               Rename: Full Path          |nvim-tree-api.fs.rename_full()|
			-- `U`               Toggle Filter: Hidden      |nvim-tree-api.tree.toggle_custom_filter()|
			-- `W`               Collapse                   |nvim-tree-api.tree.collapse_all()|
			-- `x`               Cut                        |nvim-tree-api.fs.cut()|
			-- `y`               Copy Name                  |nvim-tree-api.fs.copy.filename()|
			-- `Y`               Copy Relative Path         |nvim-tree-api.fs.copy.relative_path()|
			-- `<2-LeftMouse>`   Open                       |nvim-tree-api.node.open.edit()|
			-- `<2-RightMouse>`  CD                         |nvim-tree-api.tree.change_root_to_node()|
			local open_file = function()
				api.node.open.edit()
				vim.cmd(":NvimTreeFindFile")
			end
			local open_file_veritcal = function()
				api.node.open.vertical()
				vim.cmd(":NvimTreeFindFile")
			end

			vim.keymap.set("n", "<cr>", open_file, opts("Open"))
			vim.keymap.set("n", "o", open_file, opts("Open"))
			vim.keymap.set("n", "s", open_file_veritcal, opts("Open: Vertical Split"))
			vim.keymap.set("n", "u", api.tree.change_root_to_parent, opts("Up"))
			vim.keymap.set("n", "<C-]>", api.tree.change_root_to_node, opts("CD"))
			vim.keymap.set("n", "r", api.fs.rename_full, opts("Rename: Full Path"))
			vim.keymap.set("n", "<c-s>", api.node.run.system)
		end,
	})
end

return M
