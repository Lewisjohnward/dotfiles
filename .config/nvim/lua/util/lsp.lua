local keymap = vim.keymap

local M = {}

-- THIS IS THE SETTINGS FROM VIM

-- nmap <silent> gd <Plug>(coc-definition)
-- nmap <silent> gy <Plug>(coc-type-definition)
-- nmap <silent> gi <Plug>(coc-implementation)
-- nmap <silent> gr <Plug>(coc-references)

M.on_attach = function(client, bufnr)
	local opts = { noremap = true, silent = true, buffer = bufnr }
	vim.keymap.set("n", "<leader>fd", ":Lspsaga finder<cr>", opts) -- go to definition
	vim.keymap.set("n", "<leader>gd", ":Lspsaga peek_definition<CR>", opts) -- peak definition
	vim.keymap.set("n", "<leader>gD", ":Lspsaga goto_definition<cr>", opts) -- go to definition
	vim.keymap.set("n", "<leader>ca", ":Lspsaga code_action<cr>", opts) -- see available code actions
	vim.keymap.set("n", "<leader>rn", ":Lspsaga rename<cr>", opts) -- smart rename
	vim.keymap.set("n", "<leader>D", ":Lspsaga show_line_diagnostics<cr>", opts) -- show  diagnostics for line
	vim.keymap.set("n", "<leader>d", ":Lspsaga show_cursor_diagnostics<cr>", opts) -- show diagnostics for cursor
	vim.keymap.set("n", "<C-[>", ":Lspsaga diagnostic_jump_prev<cr>", opts) -- jump to prev diagnostic in buffer
	vim.keymap.set("n", "<C-]>", ":Lspsaga diagnostic_jump_next<cr>", opts) -- jump to next diagnostic in buffer
	-- vim.keymap.set("n", "<leader>[g", ":Lspsaga diagnostic_jump_prev<cr>", opts) -- jump to prev diagnostic in buffer
	-- vim.keymap.set("n", "<leader>]g", ":Lspsaga diagnostic_jump_next<cr>", opts) -- jump to next diagnostic in buffer
	--
	vim.keymap.set("n", "K", ":Lspsaga hover_doc<CR>", opts) -- show documentation for what is under cursor

	if client.name == "pyright" then
		keymap.set("n", "<leader>oi", "<cmd>PyrightOrganizeImports<CR>", opts)
	end
end

return M
