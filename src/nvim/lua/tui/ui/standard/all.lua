-- Module
local M = {}

--------------------------------
-- Forward function declarations
--------------------------------


----------------------------
-- Public function interface
----------------------------
M.default_config = function()
    return {
        statusline = require('tui.ui.standard.statusline').default_config(),
    }
end

M.setup = function(config)
    config = vim.tbl_deep_extend("force", M.default_config(), config or {})
    require('tui.ui.standard.statusline').setup(config.statusline)
end

-- Return Module
return M
