-- Module
local M = {}

M.default_config = function()
    return {
        colorschemes = {
            'purify',
            'tokyonight',
            'material',
        }
    }
end

M.setup = function(config)
    config = vim.tbl_deep_extend("force", M.default_config(), config or {})
end

-- Return Module
return M