return {
    "mfussenegger/nvim-dap",
    config = function()
        local dap = require('dap')

        --
        -- Adapters
        --

        local lldb_executable = '/etc/profiles/per-user/caden/bin/lldb-vscode' -- vim.fn.trim(vim.fn.system('which lldb-vscode'))
        dap.adapters.lldb = {
            type = 'executable',
            command = lldb_executable, -- adjust as needed, "must be absolute path"
            name = 'lldb'
        }


        --
        -- Configurations
        --
        dap.configurations.c = {
            {
                name = 'Launch',
                type = 'lldb',
                request = 'launch',
                program = function()
                    return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
                end,
                cwd = '${workspaceFolder}',
                stopOnEntry = false,
                args = {},
                env = function()
                    local variables = {}
                    for k, v in pairs(vim.fn.environ()) do
                        table.insert(variables, string.format("%s=%s", k, v))
                    end
                    return variables
                end,
            },
        }
        dap.configurations.cpp = dap.configurations.c
        dap.configurations.rust = {
            {
                name = 'Launch',
                type = 'lldb',
                request = 'launch',
                program = function()
                    return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
                end,
                cwd = '${workspaceFolder}',
                stopOnEntry = false,
                args = {},
                env = function()
                    local variables = {}
                    for k, v in pairs(vim.fn.environ()) do
                        table.insert(variables, string.format("%s=%s", k, v))
                    end
                    return variables
                end,
                initCommands = function()
                    -- Find out where to look for the pretty printer Python module
                    local rustc_sysroot = vim.fn.trim(vim.fn.system('rustc --print sysroot'))

                    local script_import = 'command script import "' ..
                        rustc_sysroot .. '/lib/rustlib/etc/lldb_lookup.py"'
                    local commands_file = rustc_sysroot .. '/lib/rustlib/etc/lldb_commands'

                    local commands = {}
                    local file = io.open(commands_file, 'r')
                    if file then
                        for line in file:lines() do
                            table.insert(commands, line)
                        end
                        file:close()
                    end
                    table.insert(commands, 1, script_import)

                    return commands
                end,
            },
        }

        dap.configurations.zig = {
            {
                name = 'Launch',
                type = 'lldb',
                request = 'launch',
                program = '${workspaceFolder}/zig-out/bin/zig_hello_world.exe',
                program = function()
                    local path = vim.fn.input({
                        prompt = 'Path to executable: ',
                        default = '${workspaceFolder}/zig-out/bin/',
                        completion = 'file'
                    })
                    return (path and path ~= "") and path or dap.ABORT
                end,
                cwd = '${workspaceFolder}',
                stopOnEntry = false,
                args = {},
            },
        }
    end
}
