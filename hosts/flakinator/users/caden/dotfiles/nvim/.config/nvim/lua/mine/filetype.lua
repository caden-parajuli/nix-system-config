-- Hyprlang
vim.filetype.add({
    pattern = { [".*/hypr/.*%.conf"] = "hyprlang" },
})

-- WGSL
vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
    pattern = "*.wgsl",
    callback = function()
        vim.bo.filetype = "wgsl"
    end,
})

-- Matlab/Octave
vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
    pattern = "*.mat",
    callback = function()
        vim.bo.filetype = "matlab"
    end,
})

-- Gleam
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
    pattern = "*.gleam",
    callback = function()
        vim.opt_local.shiftwidth = 2
        vim.opt_local.tabstop = 2
    end,
})

-- Kanata/kbd files
vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
    pattern = "*.kbd",
    callback = function()
        vim.bo.filetype = "kbd"
    end,
})

--Makefiles
vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
    pattern = "Makefile|makefile",
    callback = function()
        vim.opt_local.shiftwidth = 8
        vim.opt_local.tabstop = 8
        vim.opt_local.expandtab = false
    end
})
