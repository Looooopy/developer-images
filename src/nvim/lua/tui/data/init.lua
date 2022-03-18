-- Module
local M = {}

M.default_config = function()
    return {
        clipboard = require('tui.data.clipboard').default_config(),
        diagnostics = require('tui.data.diagnostics').default_config(),
        completion = require('tui.data.completion').default_config(),
        options = require('tui.data.options').default_config(),
        debug = require('tui.data.debug').default_config(),
    }
end

M.setup = function(config)
    config = vim.tbl_deep_extend("force", M.default_config(), config or {})

    require('tui.data.options').setup(config.options)
    require('tui.data.clipboard').setup(config.clipboard)
    require('tui.data.diagnostics').setup(config.diagnostics)
    require('tui.data.completion').setup(config.completion)
    require('tui.data.debug').setup(config.debug)
end

-- Return Module
return M
