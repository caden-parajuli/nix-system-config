local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
parser_config.matlab = {
    install_info = {
        url = "https://github.com/mstanciu552/tree-sitter-matlab.git",
        files = { "src/parser.c" },
        branch = 'main'
    },
    filetype = "matlab", -- if filetype does not agrees with parser name
}

require 'nvim-treesitter.configs'.setup({
    -- A list of parser names, or "all" (the five listed parsers should always be installed)
    -- ensure_installed = { "rust", "c", "ocaml", "lua", "vim", "vimdoc", "query" },
    ensure_installed = {},

    -- Install parsers synchronously (only applied to `ensure_installed`)
    sync_install = false,

    -- Automatically install missing parsers when entering buffer
    -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
    auto_install = true,

    -- List of parsers to ignore installing (or "all")
    ignore_install = {},

    highlight = {
        enable = true,
        disable = { "latex" },

        -- NOTE: these are the names of the parsers and not the filetype. (for example if you want to

        -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
        -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
        -- Using this option may slow down your editor, and you may see some duplicate highlights.
        -- Instead of true it can also be a list of languages
        additional_vim_regex_highlighting = false,--{ "markdown" },
    },
    indent = {
        enable = true,
    },
})
