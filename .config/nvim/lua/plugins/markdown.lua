return {
	-- Other plugins here...

	-- Install markdown-related plugins
	{
		"preservim/vim-markdown", -- Markdown syntax highlighting
	},
	{
		"iamcco/markdown-preview.nvim", -- Markdown preview (optional for hover, but suggested)
		build = "cd app && npm install", -- Make sure to install the necessary npm packages
	},

	-- lspsaga plugin (if not already added)
	{ "nvimdev/lspsaga.nvim" },
}
