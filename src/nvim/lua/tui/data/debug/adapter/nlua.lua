local M = {}

M.setup = function()
    config = vim.tbl_deep_extend("force", M.default_config(), config or {})

    local dap = require('dap')

    dap.adapters.nlua = config.adapter.nlua
    dap.configurations.lua = config.configuration.lua
end

M.default_config = function()
    return {
        adapter = {
            nlua = function(callback, config)
                callback({ type = 'server', host = config.host, port = config.port })
            end
        },
        configuration = {
            lua = {
                {
                    type = 'nlua',
                    request = 'attach',
                    name = "Attach to running Neovim instance",
                    host = function()
                      local value = vim.fn.input('Host [127.0.0.1]: ')
                      if value ~= "" then
                        return value
                      end
                      return '127.0.0.1'
                    end,
                    port = function()
                      local val = tonumber(vim.fn.input('Port: '))
                      assert(val, "Please provide a port number")
                      return val
                    end,
                }
            }
        },
    }
end

return M
