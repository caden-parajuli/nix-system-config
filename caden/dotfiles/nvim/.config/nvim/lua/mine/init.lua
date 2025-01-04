require("mine.remap")
require("mine.lazy")
require("mine.set")
require("mine.filetype")

-- tmux/alacritty colors 
vim.o.termguicolors = true

local augroup = vim.api.nvim_create_augroup
local MineGroup = augroup("Mine", {})

local autocmd = vim.api.nvim_create_autocmd

autocmd('LspAttach', {
    group = MineGroup,
    callback = function(e)
        local opts = { buffer = e.buf }
        vim.keymap.set("n", "<leader>ag", function() vim.lsp.buf.definition() end, opts)
        vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
        vim.keymap.set("n", "<leader>ad", function() vim.diagnostic.open_float() end, opts)
        vim.keymap.set("n", "<leader>aws", function() vim.lsp.buf.workspace_symbol() end, opts)
        vim.keymap.set("n", "<leader>and", function() vim.lsp.buf.implementation() end, opts)
        vim.keymap.set("n", "<leader>ac", function() vim.lsp.buf.code_action() end, opts)
        vim.keymap.set("n", "<leader>arf", function() vim.lsp.buf.references() end, opts)
        vim.keymap.set("n", "<leader>arn", function() vim.lsp.buf.rename() end, opts)
        vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
        vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, opts)
        vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, opts)
    end
})

