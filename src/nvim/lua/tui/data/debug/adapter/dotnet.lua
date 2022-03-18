local M = {}


M.setup = function()
    config = vim.tbl_deep_extend("force", M.default_config(), config or {})

    local dap = require('dap')

    dap.adapters.netcoredbg = config.adapter.netcoredbg
    dap.configurations.cs = config.configuration.cs
end

M.default_config = function()
    return {
        adapter = {
            netcoredbg = {
                type = 'executable',
                command = '/tmp/dotnet/netcoredbg/netcoredbg',
                args = {'--interpreter=vscode', '--engineLogging=/tmp/netcoredbg.log'},
                options = {
                    env = {
                        ASPNETCORE_ENVIRONMENT = 'Development',
                    },
                },
            },
        },
        configuration = {
            cs = {
                {
                    type = 'netcoredbg',
                    name = 'launch - netcoredbg',
                    request = 'launch',
                    program = function()
                        -- TODO: fix better function how to find dll's
                        return vim.fn.input('Path to dll: ', vim.fn.getcwd() .. '/bin/Debug/net6.0', 'file')
                    end,
                },
                {
                    type = 'netcoredbg',
                    name = 'attach - netcoredbg',
                    request = 'attach',
                    processId = require("dap.utils").pick_process,
                },
            }
        }
    }
end

return M
