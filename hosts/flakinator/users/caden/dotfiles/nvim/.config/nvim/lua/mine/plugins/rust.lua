-- RustaceanVim Rust LSP
return {
    {
        'mrcjkb/rustaceanvim',
        version = '^6', -- Recommended
        lazy = false,   -- This plugin is already lazy
        config = function()
            vim.g.rustaceanvim = {
                server = {
                    default_settings = {
                        ['rust-analyzer'] = {
                            ["cargo"] = {
                                ["buildScripts"] = {
                                    ["enable"] = true,
                                },
                            },
                        },
                    },
                },
            }
        end
    }
}
