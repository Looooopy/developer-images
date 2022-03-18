-- Module
local M = {}

local _config

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
    _config = vim.tbl_deep_extend("force", M.default_config(), config or {})
end

M.random = function(config)
    config = config or _config

    math.randomseed(os.time())
    local index = math.random(1, #(config.colorschemes))
    local colorscheme = config.colorschemes[index]
    if colorscheme == 'tokyonight' then
        local t = os.date ("*t")
        if  t.hour > 11 and t.hour < 14 then
            vim.g.tokyonight_style = 'day'
        elseif t.hour > 14 and t.hour < 18 then
            vim.g.tokyonight_style = 'night'
        else
            vim.g.tokyonight_style = 'storm'
        end
    end

    vim.cmd('colorscheme '..colorscheme)
end

-- Return Module
return M
