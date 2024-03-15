return {
	"hrsh7th/nvim-cmp",
	config = function()
		local cmp = require("cmp")
		local luasnip = require("luasnip")
		local lspkind = require("lspkind")

		-- require("luasnip/loaders/from_vscode").lazy_load({ paths = "~/.config/nvim/snippets/" })
		require("luasnip/loaders/from_lua").lazy_load({ paths = "~/.config/nvim/snippets/" })
		require("luasnip/loaders/from_vscode").lazy_load()
		-- require("luasnip/loaders/from_vscode").load_standalone({
		-- 	path = "~/.config/nvim/snippets/snippets.code-snippets",
		-- })

		luasnip.config.set_config({
			history = true,
			update = "TextChanged, TextChangedI",
			enable_autosnippets = true,
			ext_opts = {
				[require("luasnip.util.types").choiceNode] = {
					active = {
						-- virt_text = { { ".", "GruvboxOrange" } },
					},
				},
			},
		})

		vim.opt.completeopt = "menu,menuone,noselect"

		cmp.setup({
			snippet = {
				expand = function(args)
					luasnip.lsp_expand(args.body)
				end,
			},
			mapping = cmp.mapping.preset.insert({
				["<C-k>"] = cmp.mapping.select_prev_item(), -- previous suggestion
				["<C-j>"] = cmp.mapping.select_next_item(), -- next suggestion
				["<C-b>"] = cmp.mapping.scroll_docs(-4),
				["<C-f>"] = cmp.mapping.scroll_docs(4),
				["<C-Space>"] = cmp.mapping.complete(), -- show completion suggestions
				["<C-e>"] = cmp.mapping.abort(), -- close completion window
				["<CR>"] = cmp.mapping.confirm({ select = false }),
			}),
			-- sources for autocompletion
			sources = cmp.config.sources({
				{ name = "nvim_lsp" }, -- lsp
				{ name = "luasnip" }, -- snippets
				{ name = "buffer" }, -- text within current buffer
				{ name = "path" }, -- file system paths
			}),
			-- configure lspkind for vs-code like icons
			formatting = {
				format = lspkind.cmp_format({
					maxwidth = 50,
					ellipsis_char = "...",
				}),
			},
		})
	end,
	dependencies = {
		"onsails/lspkind.nvim",
		{

			"L3MON4D3/LuaSnip",
			-- follow latest release.
			version = "2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
			-- install jsregexp (optional!).
			build = "make install_jsregexp",
			dependencies = {
				"rafamadriz/friendly-snippets",
			},
		},
		"saadparwaiz1/cmp_luasnip",
	},
}
