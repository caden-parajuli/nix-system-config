return {
    -- DCS plugin
    {
        -- dir = "~/.vim/pack/mine/start/dcs-vim",
        dir = "~/projects/dcs-vim",
        config = function()
            require('dcs').setup{
                backend = "/home/caden/collaboration/chronolog_env/dcs-new/backend/dist/dcs",
                root_list = { "/home/caden/collaboration/chronolog_env/dcs-new/Stdlib" },
                debug = false,
            }
        end
    },
}
