-- Module
local M = {}

function M.setup(config)
    config = vim.tbl_deep_extend("force", M.default_config(), config or {})
    require'colorizer'.setup(config)
end

function M.default_config()
    return {}
end

-- Return Module
return M
