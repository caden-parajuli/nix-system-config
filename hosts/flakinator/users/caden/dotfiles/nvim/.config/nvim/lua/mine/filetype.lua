-- New filetypes
vim.filetype.add({
    pattern = {
        [".*/hypr/.*%.conf"] = "hyprlang",
    },
    extension = {
        wgsl = "wgsl",
    }
})

-- Gleam
vim.api.nvim_create_autocmd({ "Filetype" }, {
    pattern = "gleam",
    callback = function()
        vim.opt_local.shiftwidth = 2
        vim.opt_local.tabstop = 2
    end,
})

-- Go
vim.api.nvim_create_autocmd({ "Filetype" }, {
    pattern = "go",
    callback = function()
        vim.opt_local.shiftwidth = 4
        vim.opt_local.tabstop = 4
    end,
})

-- OCaml
vim.api.nvim_create_autocmd({ "Filetype" }, {
    pattern = "ocaml",
    callback = function()
        vim.opt_local.shiftwidth = 2
        vim.opt_local.tabstop = 2
    end,
})
-- vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
--     pattern = "\\m*.ml\\|*.mli",
--     callback = function()
--         vim.bo.filetype = "ocaml"
--         vim.opt_local.shiftwidth = 2
--         vim.opt_local.tabstop = 2
--     end,
-- })
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

--Makefile
vim.api.nvim_create_autocmd({ "Filetype" }, {
    pattern = "make",
    callback = function()
        vim.opt_local.shiftwidth = 8
        vim.opt_local.tabstop = 8
        vim.opt_local.expandtab = false
    end
})

--Lua
vim.api.nvim_create_autocmd({ "Filetype" }, {
    pattern = "lua",
    callback = function()
        vim.opt_local.shiftwidth = 2
        vim.opt_local.tabstop = 2
    end
})

-- Agda
vim.api.nvim_create_autocmd({ "Filetype" }, {
    pattern = "agda",
    callback = function()
        vim.keymap.set("n", "<LocalLeader>cl", "<CMD>CornelisLoad<CR>")
        vim.keymap.set("n", "<LocalLeader>c?", "<CMD>CornelisGoals<CR>")
        vim.keymap.set("n", "<LocalLeader>xr", "<CMD>CornelisRestart<CR>")
        vim.keymap.set("n", "<LocalLeader>xa", "<CMD>CornelisAbort<CR>")
        vim.keymap.set("n", "<LocalLeader>cs", "<CMD>CornelisSolve")
        vim.keymap.set("n", "<LocalLeader>ag", "<CMD>CornelisGoToDefinition<CR>")
        vim.keymap.set("n", "<LocalLeader>cb", "<CMD>CornelisPrevGoal<CR>")
        vim.keymap.set("n", "<LocalLeader>cf", "<CMD>CornelisNextGoal<CR>")
        vim.keymap.set("n", "<LocalLeader><C-a>", "<CMD>CornelisInc<CR>")
        vim.keymap.set("n", "<LocalLeader><C-x>", "<CMD>CornelisDec<CR>")
        vim.keymap.set("n", "<LocalLeader>on", "<CMD>CornelisCloseInfoWindows<CR>")

        -- Goal commands
        vim.keymap.set("n", "<LocalLeader>c ", "<CMD>CornelisGive<CR>")
        vim.keymap.set("n", "<LocalLeader>cr", "<CMD>CornelisRefine<CR>")
        vim.keymap.set("n", "<LocalLeader>cm", "<CMD>CornelisElaborate<CR>")
        vim.keymap.set("n", "<LocalLeader>ca", "<CMD>CornelisAuto<CR>")
        vim.keymap.set("n", "<LocalLeader>cc", "<CMD>CornelisMakeCase<CR>")
        vim.keymap.set("n", "<LocalLeader>c,", "<CMD>CornelisTypeContext<CR>")
        vim.keymap.set("n", "<LocalLeader>cn", "<CMD>CornelisNormalize<CR>")
        vim.keymap.set("n", "<LocalLeader>cw", "<CMD>CornelisWhyInScope<CR>")
        vim.keymap.set("n", "<LocalLeader>ch", "<CMD>CornelisHelperFunc<CR>")
    end,
})
