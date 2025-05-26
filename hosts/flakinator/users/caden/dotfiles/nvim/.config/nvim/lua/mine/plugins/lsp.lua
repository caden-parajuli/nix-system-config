return {
    "neovim/nvim-lspconfig",
    dependencies = {
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-cmdline",
        "hrsh7th/nvim-cmp",
        "L3MON4D3/LuaSnip",
        "saadparwaiz1/cmp_luasnip",
        "j-hui/fidget.nvim",
    },

    config = function()
        local cmp = require('cmp')
        local cmp_lsp = require("cmp_nvim_lsp")
        local capabilities = vim.tbl_deep_extend(
            "force",
            {},
            vim.lsp.protocol.make_client_capabilities(),
            cmp_lsp.default_capabilities())

        require("fidget").setup({})

        local lspconfig = require("lspconfig")
        local configs = require("lspconfig")

        -- Lua
        lspconfig.lua_ls.setup {
            on_init = function(client)
                local path = client.workspace_folders[1].name
                if vim.loop.fs_stat(path .. '/.luarc.json') or vim.loop.fs_stat(path .. '/.luarc.jsonc') then
                    return
                end

                client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
                    runtime = {
                        version = 'LuaJIT'
                    },
                    -- Make the server aware of Neovim runtime files
                    workspace = {
                        checkThirdParty = false,
                        library = {
                            vim.env.VIMRUNTIME
                        }
                    }
                })
            end,
            settings = {
                Lua = {
                    telementry = { enable = false },
                    diagnostics = { disable = { 'missing-fields' } },
                }
            }
        }

        -- Nix
        lspconfig.nil_ls.setup {
            autostart = true,
            settings = {
                ['nil'] = {
                    testSetting = 42,
                    formatting = {
                        command = { "nixfmt" },
                    },
                },
            },
        }

        -- WGSL
        if not configs.wgsl_analyzer then
            configs.wgsl_analyzer = {
                default_config = {
                    cmd = { "~/.cargo/bin/wgsl_analyzer" },
                    filetypes = { "wgsl" },
                    root_dir = lspconfig.util.root_pattern(".git", "wgsl"),
                    settings = {},
                },
            }
        end
        lspconfig.wgsl_analyzer.setup({ capabilities = capabilities, })

        -- C (clangd)
        lspconfig.clangd.setup({
            on_init = function(client)
                local arg_file_name = '.clangd-args'
                local path = client.workspace_folders[1].name
                local clangd_args_path = vim.fn.fnamemodify(path, ':p') .. arg_file_name

                if (vim.fn.filereadable(clangd_args_path) ~= 0) then
                    local clangd_cmd = {}
                    for line in io.lines(clangd_args_path) do
                        -- Add an argument from each line, stripping spaces
                        clangd_cmd[#clangd_cmd + 1] = string.gsub(line, '^%s*(.-)%s*$', '%1')
                    end
                    client.config.settings["clangd"].cmd = clangd_cmd
                end

                client.notify("workspace/didChangeConfiguration", { settings = client.config.settings })
                return true
            end,
            settings = {
                ['clangd'] = { cmd = {} }
            }
        })

        -- OCaml
        lspconfig.ocamllsp.setup({})

        -- Gleam
        lspconfig.gleam.setup({})

        -- Go
        lspconfig.gopls.setup({})

        -- Nim
        lspconfig.nim_langserver.setup({})

        -- Zig
        lspconfig.zls.setup({
            settings = {
                zls = {
                    enable_snippets = true,
                    warn_style = true,
                    enable_build_on_save = true,
                    -- build_on_save_step = "check",
                }
            }
        })

        -- Haskell
        lspconfig.hls.setup({
            filetypes = { 'haskell', 'lhaskell', 'cabal' },
            root_dir = lspconfig.util.root_pattern("hie.yaml", "stack.yaml", "cabal.project", "*.cabal", "package.yaml",
                ".git"),
        })

        -- Python (pylsp)
        lspconfig.pylsp.setup({
            cmd = { "uv", "run", "pylsp" },
            settings = {
                pylsp = {
                    plugins = {
                        ruff = {
                            enabled = true,
                            formatEnabled = true,
                            unsafeFixes = true,
                            lineLength = 79,
                            format = { "I" },
                        },
                        pylsp_mypy = {
                            enabled = true,
                            dmypy = true,
                        },
                        rope_autoimport = {
                            enabled = true,
                        },
                    },
                }
            }
        })
        -- lspconfig.pyright.setup({
        --     capabilities = (function()
        --         local caps = vim.lsp.protocol.make_client_capabilities()
        --         caps.textDocument.publishDiagnostics.tagSupport.valueSet = { 2 }
        --         return caps
        --     end)(),
        --     settings = {
        --         python = {
        --             analysis = {
        --                 useLibraryCodeForTypes = true,
        --                 diagnosticSeverityOverrides = {
        --                     reportUnusedVariable = "warning", -- or anything
        --                 },
        --                 -- typeCheckingMode = "basic",
        --             },
        --         },
        --     },
        -- })
        -- lspconfig.ruff.setup({
        --     on_attach = function(client, _) client.server_capabilities.hoverProvider = false end,
        -- })

        -- Lean
        lspconfig.leanls.setup({})

        -- Java
        lspconfig.jdtls.setup({})

        -- Emmet HTML
        lspconfig.emmet_language_server.setup({
            filetypes = { "css", "eruby", "html", "less", "sass", "scss" },
        })

        -- JSON
        lspconfig.jsonls.setup({
            init_options = {
                provideFormatter = true
            }
        })

        -- LaTeX
        lspconfig.texlab.setup({})

        -- Scala (metals)
        lspconfig.metals.setup{
            -- message_level = 2,
            init_options = {
                statusBarProvider = "",
            },
        }

        -- Completion
        local cmp_select = { behavior = cmp.SelectBehavior.Select }
        cmp.setup({
            snippet = {
                expand = function(args)
                    require('luasnip').lsp_expand(args.body)
                end,
            },
            mapping = cmp.mapping.preset.insert({
                ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
                ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
                ['<C-y>'] = cmp.mapping.confirm({ select = true }),
                ["<C-Space>"] = cmp.mapping.complete(),
            }),
            sources = cmp.config.sources({
                { name = 'nvim_lsp' },
                { name = 'luasnip' },
                { name = 'render-markdown' },
            }, {
                { name = 'buffer' },
            })
        })

        -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
        cmp.setup.cmdline({ '/', '?' }, {
            mapping = cmp.mapping.preset.cmdline(),
            sources = {
                { name = 'buffer' }
            }
        })

        -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
        cmp.setup.cmdline(':', {
            mapping = cmp.mapping.preset.cmdline(),
            sources = cmp.config.sources({
                { name = 'path' }
            }, {
                { name = 'cmdline' }
            }),
            matching = { disallow_symbol_nonprefix_matching = false }
        })

        vim.diagnostic.config({
            -- update_in_insert = true,
            float = {
                focusable = false,
                style = "minimal",
                border = "rounded",
                source = "always",
                header = "",
                prefix = "",
            },
        })
    end
}
