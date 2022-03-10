-- Module
local M = {}

M.default_config = function()
    return {
        visability = require('tui.ui.visibility.all').default_config(),
        standard = require('tui.ui.standard.all').default_config(),
    }
end

M.setup = function(config)
    config = vim.tbl_deep_extend("force", M.default_config(), config or {})

    require('tui.ui.visibility.all').setup(config.visability)
    require('tui.ui.standard.all').setup(config.standard)
end

-- Return Module
return M
