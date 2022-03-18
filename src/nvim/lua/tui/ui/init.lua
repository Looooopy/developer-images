-- Module
local M = {}

M.default_config = function()
    return {
        visability = require('tui.ui.visibility').default_config(),
        standard = require('tui.ui.standard').default_config(),
        colourscheme = require('tui.ui.colourscheme').default_config(),
    }
end

M.setup = function(config)
    config = vim.tbl_deep_extend("force", M.default_config(), config or {})

    require('tui.ui.visibility').setup(config.visability)
    require('tui.ui.standard').setup(config.standard)
    require('tui.ui.colourscheme').setup(config.colourscheme)
end

-- Return Module
return M
