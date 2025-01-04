return {
    {
        'echasnovski/mini.ai',
        version = false,
        config = function()
            require('mini.ai').setup()
        end
    },
    {
        'echasnovski/mini.surround',
        version = false,
        config = function()
            require('mini.surround').setup()
        end
    },
    { 'echasnovski/mini.bracketed',
        version = false,
        config = function ()
            require('mini.bracketed').setup()
        end
    },
    -- { 'echasnovski/mini.jump2d',
    --     version = false,
    --     config = function ()
    --         require('mini.jump2d').setup()
    --     end
    -- },
    { 'echasnovski/mini.align',
        version = false,
        config = function ()
            require('mini.align').setup()
        end
    },
}
