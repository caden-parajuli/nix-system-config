local ls = require("luasnip")

-- Use Tab for completion
vim.keymap.set({ "i" }, "<Tab>", function()
        if ls.expand_or_jumpable()
        then
            ls.expand_or_jump()
        else
            return "<Tab>"
        end
    end,
    { silent = true, remap = false })

vim.keymap.set({ "s" }, "<Tab>", function()
        if ls.jumpable(1)
        then
            ls.jump(1)
        else
            return "<Tab>"
        end
    end,
    { silent = true })

-- S-Tab to jump backwards
vim.keymap.set({ "i", "s" }, "<S-Tab>", function() ls.jump(-1) end, { silent = true })

-- C-E to cycle snippets
vim.keymap.set({ "i", "s" }, "<C-E>", function()
    if ls.choice_active() then
        ls.change_choice(1)
    end
end, { silent = true })

ls.config.set_config({
    enable_auto_snippets = true,
    cut_selection_keys = "<Tab>",
})

-- Load snippets
require("luasnip.loaders.from_lua").lazy_load({ paths = { "~/.config/nvim/luasnippets/" } })
