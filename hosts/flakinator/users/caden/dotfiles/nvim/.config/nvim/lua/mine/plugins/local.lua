return {
    -- DCS plugin
    {
        dir = "~/projects/dcs.vim",
        config = function()
            require('dcs').setup({
                backend = "/home/caden/collaboration/chronolog_env/dcs-new/dcs-backend/dist/dcs",
                debug = true,
            })
        end
    },
}
