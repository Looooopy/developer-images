local M = {}

M.default_config = function()
    return {
      lua = require('tui.data.debug.adapter.nlua').default_config(),
      cs = require('tui.data.debug.adapter.dotnet').default_config(),
    }
end

M.setup = function(config)
    config = vim.tbl_deep_extend("force", M.default_config(), config or {})

    require('tui.data.debug.adapter.nlua').setup(config.lua)
    require('tui.data.debug.adapter.dotnet').setup(config.cs)
end

return M
