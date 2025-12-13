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

-- Go
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
    pattern = "*.go",
    callback = function()
        vim.opt_local.shiftwidth = 4
        vim.opt_local.tabstop = 4
    end,
})

-- OCaml
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
    pattern = "\\m*.ml\\|*.mli",
    callback = function()
        vim.bo.filetype = "ocaml"
        vim.opt_local.shiftwidth = 2
        vim.opt_local.tabstop = 2
    end,
})
-- ReasonML
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
    pattern = "\\m*.re\\|*.rei",
    callback = function()
        vim.bo.filetype = "reason"
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
    pattern = "Makefile\\|makefile",
    callback = function()
        vim.opt_local.shiftwidth = 8
        vim.opt_local.tabstop = 8
        vim.opt_local.expandtab = false
    end
})
