return {
    -- telescope
    {
        'nvim-telescope/telescope.nvim',
        tag = '0.1.6',
        dependencies = { 'nvim-lua/plenary.nvim' },
    },

    -- treesitter
    {
        'nvim-treesitter/nvim-treesitter',
        build = ':TSUpdate'
    },

    -- harpoon
    {
        "ThePrimeagen/harpoon",
        branch = "harpoon2",
        dependencies = { "nvim-lua/plenary.nvim", "nvim-telescope/telescope.nvim", },
    },

    -- undo tree
    {
        'mbbill/undotree'
    },

    -- fugitive git
    {
        'tpope/vim-fugitive',
        name = "fugitive",
    },

    -- LuaSnip snippets
    {
        "L3MON4D3/LuaSnip",
        version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
        dependencies = { "rafamadriz/friendly-snippets" },
    },

    -- RustaceanVim Rust LSP
    {
        'mrcjkb/rustaceanvim',
        version = '^4', -- Recommended
        lazy = false,   -- This plugin is already lazy
    },

    -- telescope cht.sh integration
    {
        "nvim-telescope/telescope-cheat.nvim",
        dependencies = {
            "kkharji/sqlite.lua",
            "nvim-telescope/telescope.nvim"
        }
    },

    -- characterize, modern character information
    {
        "tpope/vim-characterize",
        name = "characterize",
        tag = "v1.1",
    },

    -- eunuch, *NIX utilities
    {
        "tpope/vim-eunuch",
        name = "eunuch",
        tag = "v1.3",
    },

    -- {
    --     'windwp/nvim-autopairs',
    --     event = "InsertEnter",
    --     config = true
    --     -- use opts = {} for passing setup options
    --     -- this is equalent to setup({}) function
    -- },

    -- endwise, automatic ending of certain blocks
    {
        "RRethy/nvim-treesitter-endwise",
        lazy = false,
        name = "endwise",
        dependencies = { 'nvim-treesitter/nvim-treesitter', },
    },

    -- repeat, better . repeat with plugins
    {
        "tpope/vim-repeat",
        name = "repeat",
        tag = "v1.2",
    },

    -- cutlass, don't cut when deleting
    {
        "gbprod/cutlass.nvim",
        opts = {
            cut_key = "x",
            override_del = true,
            exclude = {},
            --     registers = {
            --         select = "s",
            --         delete = "d",
            --         change = "c",
            --         },
        },
    },

    -- commenting
    {
        'numToStr/Comment.nvim',
        opts = {
            -- add any options here
        },
        lazy = false,
    },

    -- Debug adapter
    {
        'mfussenegger/nvim-dap'
    },

    -- Highlights changed region in undo
    {
        'tzachar/highlight-undo.nvim',
    },

    -- Neogen, annotation generator
    {
        "danymat/neogen",
        config = true,
        -- Uncomment next line if you want to follow only stable versions
        -- version = "*"
    },

    -- Oil, file manager
    {
        'stevearc/oil.nvim',
        opts = {},
        -- Optional dependencies
        dependencies = { "nvim-tree/nvim-web-devicons" },
    },

    -- FireNvim, Nvim in browser
    -- {
    --     'glacambre/firenvim',
    --
    --     -- Lazy load firenvim
    --     -- Explanation: https://github.com/folke/lazy.nvim/discussions/463#discussioncomment-4819297
    --     lazy = not vim.g.started_by_firenvim,
    --     build = function()
    --         vim.fn["firenvim#install"](0)
    --     end
    -- },

    -- Haskell Tools
    {
        'mrcjkb/haskell-tools.nvim',
        version = '^4', -- Recommended
        lazy = false,   -- This plugin is already lazy
    },

    -- Octave
    {
        'mstanciu552/cmp-octave'
    },

    -- Flutter
    {
        'akinsho/flutter-tools.nvim',
        lazy = false,
        dependencies = {
            'nvim-lua/plenary.nvim',
            'stevearc/dressing.nvim', -- optional for vim.ui.select
        },
        config = true,
    },

    -- LaTeX
    {
        "lervag/vimtex",
        lazy = false, -- we don't want to lazy load VimTeX
        -- tag = "v2.15", -- uncomment to pin to a specific release
        init = function()
            -- VimTeX configuration goes here, e.g.
            vim.g.vimtex_view_method = "zathura"
            vim.g.vimtex_compiler_method = 'latexmk'
            vim.g.vimtex_quickfix_mode = 0
        end
    },

    -- Null/None LS
    {
        "nvimtools/none-ls.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            local null_ls = require("null-ls")

            null_ls.setup({
                sources = {
                    null_ls.builtins.formatting.black,
                    null_ls.builtins.completion.spell.with({
                        filetypes = { "markdown", "tex", "latex" },
                    }),
                    null_ls.builtins.formatting.prettierd.with({
                        filetypes = { "css", "scss", "less", "html", "yaml", }
                    }),
                },
            })
            null_ls.disable({ filetype = "javascript" })
            null_ls.disable({ filetype = "python" })
        end
    },

    -- Markdown FeMaco
    {
        'AckslD/nvim-FeMaco.lua',
        config = function() require("femaco").setup() end,
    },

    -- Sleuth, guess indentation
    {
        'tpope/vim-sleuth',
    },

    -- Lean
    {
        'Julian/lean.nvim',
        event = { 'BufReadPre *.lean', 'BufNewFile *.lean' },

        dependencies = {
            'neovim/nvim-lspconfig',
            'nvim-lua/plenary.nvim',
            'hrsh7th/nvim-cmp',
            'AndrewRadev/switch.vim'
        },

        opts = {
            lsp = {},
            mappings = true,
        }
    },

    -- Agda
    {
        "ashinkarov/nvim-agda",
        config = function()
            vim.g.nvim_agda_settings = {
                agda_args = { "--include-path=/home/caden/bc/fall_2024/pl/ial" },
            }
        end
    },

    -- marks.nvim, better marks
    {
        "chentoast/marks.nvim",
        -- event = "VeryLazy",
        opts = {},
    },

    -- Lilypond-Suite
    {
        "martineausimon/nvim-lilypond-suite",
        config = function()
            require('nvls').setup({})
        end
    },

    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        opts = {
            delay = function(ctx)
                return ctx.plugin and 0 or 600
            end,
        },
        keys = {
            {
                "<leader>?",
                function()
                    require("which-key").show({ global = false })
                end,
                desc = "Buffer Local Keymaps (which-key)",
            },
        },
    },

    -- Snacks.nvim, lots of little things
    {
        "folke/snacks.nvim",
        priority = 1000,
        lazy = false,
        opts = {
            -- your configuration comes here
            -- or leave it empty to use the default settings
            -- refer to the configuration section below
            bigfile = { enabled = true },
            dashboard = { enabled = true },
            notifier = {
                enabled = true,
                style = "fancy",
                width = { min = 70, max = 0.5 },
                height = { min = 1, max = 0.6 },
            },
            quickfile = { enabled = true },
            statuscolumn = { enabled = true },
            styles = {
                notification = {
                    wo = { wrap = true } -- Wrap notifications
                }
            }
        },
        keys = {
            { "<leader>.",  function() Snacks.scratch() end,            desc = "Toggle Scratch Buffer" },
            { "<leader>S",  function() Snacks.scratch.select() end,     desc = "Select Scratch Buffer" },
            { "<leader>bd", function() Snacks.bufdelete() end,          desc = "Delete Buffer" },
            { "<leader>cR", function() Snacks.rename.rename_file() end, desc = "Rename File" },
            { "<leader>gB", function() Snacks.gitbrowse() end,          desc = "Git Browse" },
            { "<leader>un", function() Snacks.notifier.hide() end,      desc = "Dismiss All Notifications" },
            { "<c-/>",      function() Snacks.terminal() end,           desc = "Toggle Terminal" },
            { "<c-_>",      function() Snacks.terminal() end,           desc = "which_key_ignore" },
        },
    },

    -- Coq
    { "whonore/Coqtail", },
    {
        "tomtomjhj/coq-lsp.nvim",
        config = function()
            vim.g.loaded_coqtail = 1
            vim.g["coqtail#supported"] = 0
            require("coq-lsp").setup{}
        end
    },

    -- Typst
    {
        "chomosuke/typst-preview.nvim",
        lazy = false, -- or ft = 'typst'
        version = '1.*',
        opts = {
            dependencies_bin = {
                ['tinymist'] = "/etc/profiles/per-user/caden/bin/tinymist",
                ['websocat'] = "/etc/profiles/per-user/caden/bin/websocat"
            }
        },
    }
}
