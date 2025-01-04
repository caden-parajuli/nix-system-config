local function on_attach(_, bufnr)
	local function cmd(mode, lhs, rhs)
		vim.keymap.set(mode, lhs, rhs, { noremap = true, buffer = true })
	end

	-- Autocomplete using the Lean language server
	vim.api.nvim_set_option_value('omnifunc', 'v:lua.vim.lsp.omnifunc', { scope = "local" })

	-- <leader>n will jump to the next Lean line with a diagnostic message on it
	-- <leader>N will jump backwards
	cmd('n', '<leader>n', function() vim.diagnostic.goto_next { popup_opts = { show_header = false } } end)
	cmd('n', '<leader>N', function() vim.diagnostic.goto_prev { popup_opts = { show_header = false } } end)

	-- <leader>q will load all errors in the current lean file into the location list
	-- (and then will open the location list)
	-- see :h location-list if you don't generally use it in other vim contexts
	cmd('n', '<leader>q', vim.diagnostic.setloclist)
end

require('lean').setup {
	lsp = { on_attach = on_attach },
	mappings = true,
}
