-- Module
local M = {}

M.default_config = function()
    return {
        clipboard = require('tui.data.clipboard.module').default_config()
    }
end

M.setup = function(config)
    config = vim.tbl_deep_extend("force", M.default_config(), config or {})

    require('tui.data.clipboard.module').setup(config.clipboard)
end

-- Return Module
return M