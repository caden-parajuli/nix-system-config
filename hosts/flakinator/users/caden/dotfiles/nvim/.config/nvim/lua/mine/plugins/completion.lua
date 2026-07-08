return {
    {
        "xzbdmw/colorful-menu.nvim",
        config = function() end,
    },
    {
        'saghen/blink.cmp',
        dependencies = {
            'rafamadriz/friendly-snippets',
            "xzbdmw/colorful-menu.nvim",
        },

        -- use a release tag to download pre-built binaries
        version = '1.*',

        ---@module 'blink.cmp'
        ---@type blink.cmp.Config
        opts = {
            keymap = { preset = 'default' },

            appearance = {
                -- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
                -- Adjusts spacing to ensure icons are aligned
                nerd_font_variant = 'mono'
            },

            completion = {
                ghost_text = { enabled = false },
                documentation = {
                    auto_show = true,
                    auto_show_delay_ms = 200,
                },
                menu = {
                    auto_show = true,
                    draw = {
                        -- We don't need label_description now because label and label_description
                        -- are already combined together in label by colorful-menu.nvim.
                        columns = { { "kind_icon" }, { "label", gap = 1 } },
                        components = {
                            label = {
                                text = function(ctx)
                                    return require("colorful-menu").blink_components_text(ctx)
                                end,
                                highlight = function(ctx)
                                    return require("colorful-menu").blink_components_highlight(ctx)
                                end,
                            },
                        },
                    },
                },
            },

            sources = { default = { 'lsp', 'path', 'snippets', 'buffer', 'cmdline' } },

            snippets = { preset = 'luasnip' },

            fuzzy = { implementation = "prefer_rust_with_warning" },

            cmdline = {
                completion = {
                    menu = { auto_show = function() return true end },
                },
            },
        },

        signature = { enabled = true },
        opts_extend = { "sources.default" }
    },
}
