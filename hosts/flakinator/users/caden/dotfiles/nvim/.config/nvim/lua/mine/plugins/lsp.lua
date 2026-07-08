return {
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            "saghen/blink.cmp",
            "L3MON4D3/LuaSnip",
            "j-hui/fidget.nvim",
        },

        config = function()
            local cmp = require('blink.cmp')
            local capabilities = cmp.get_lsp_capabilities()

            require("fidget").setup({})

            -- Lua
            vim.lsp.config('lua_ls', {
                on_init = function(client)
                    if client.workspace_folders and #(client.workspace_folders) > 1 then
                        local path = client.workspace_folders[1].name
                        if vim.loop.fs_stat(path .. '/.luarc.json') or vim.loop.fs_stat(path .. '/.luarc.jsonc') then
                            return
                        end
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
            })
            vim.lsp.enable('lua_ls')

            -- Nix
            vim.lsp.config('nil_ls', {
                autostart = true,
                settings = {
                    ['nil'] = {
                        testSetting = 42,
                        formatting = {
                            command = { "nixfmt" },
                        },
                    },
                },
            })
            vim.lsp.enable('nil_ls')

            -- WGSL
            -- vim.lsp.config('wgsl_analyzer', { capabilities = capabilities, })

            -- C (clangd)
            vim.lsp.config('clangd', {
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

                    client:notify("workspace/didChangeConfiguration", { settings = client.config.settings })
                    return true
                end,
                settings = {
                    ['clangd'] = { cmd = {} }
                }
            })
            vim.lsp.enable('clangd')

            -- OCaml
            vim.lsp.config('ocamllsp', {
                cmd = { "ocamllsp", "--fallback-read-dot-merlin" },
                filetypes = { "ocaml", "menhir", "ocamlinterface", "ocamllex", "reason", "dune" }
            })
            vim.lsp.enable('ocamllsp')

            -- Gleam
            vim.lsp.config('gleam', {})
            vim.lsp.enable('gleam')

            -- Go
            vim.lsp.config('gopls', {})
            vim.lsp.enable('gopls')

            -- Nim
            vim.lsp.config('nim_langserver', {})
            vim.lsp.enable('nim_langserver')

            -- Zig
            vim.lsp.config('zls', {
                settings = {
                    zls = {
                        enable_snippets = true,
                        warn_style = true,
                        enable_build_on_save = true,
                        -- build_on_save_step = "check",
                    }
                }
            })
            vim.lsp.enable('zls')

            -- We have haskell-tools
            -- -- Haskell
            -- vim.lsp.config('hls',{
            --     filetypes = { 'haskell', 'lhaskell', 'cabal' },
            -- })
            -- vim.lsp.enable('hls')

            -- Python (pylsp)
            vim.lsp.config('pylsp', {
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
            vim.lsp.enable('pylsp')
            -- vim.lsp.config('pyright',{
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
            -- vim.lsp.config('ruff',{
            --     on_attach = function(client, _) client.server_capabilities.hoverProvider = false end,
            -- })

            -- Lean
            vim.lsp.config('leanls', {})
            vim.lsp.enable('leanls')

            -- Java
            vim.lsp.config('jdtls', {})
            vim.lsp.enable('jdtls')

            -- Emmet HTML
            vim.lsp.config('emmet_language_server', {
                filetypes = { "css", "eruby", "html", "less", "sass", "scss" },
            })
            vim.lsp.enable('emmet_language_server')

            -- JSON
            vim.lsp.config('jsonls', {
                init_options = {
                    provideFormatter = true
                }
            })
            vim.lsp.enable('jsonls')

            -- LaTeX
            vim.lsp.config('texlab', {})
            vim.lsp.enable('texlab')

            -- Typst
            vim.lsp.config('tinymist', {
                cmd = { "tinymist" },
                filetypes = { "typst" },
                settings = {
                    formatterMode = "typstyle",
                    exportPdf = "onType",
                    semanticTokens = "disable"
                }
            })
            vim.lsp.enable('tinymist')

            -- Scala (metals)
            vim.lsp.config('metals', {
                -- message_level = 2,
                init_options = {
                    statusBarProvider = "",
                },
            })
            vim.lsp.enable('metals')

            -- QML
            vim.lsp.config('qmlls', {
                cmd = { "qmlls", "-E" }
            })
            vim.lsp.enable('qmlls')

            vim.lsp.config('astro', {})
            vim.lsp.enable('astro')

            vim.diagnostic.config({
                update_in_insert = true,
                float = {
                    focusable = false,
                    style = "minimal",
                    border = "rounded",
                    source = true,
                    header = "",
                    prefix = "",
                },
            })
        end
    }
}
