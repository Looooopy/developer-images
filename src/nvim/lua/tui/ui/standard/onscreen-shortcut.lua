-- Module
local M = {}

function M.setup(config)
    config = vim.tbl_deep_extend("force", M.default_config(), config or {})
    require("which-key").setup(config)
end

function M.default_config()
    return {
        icons = {
          breadcrumb = "»", -- Default: '»', symbol used in the command line area that shows your active key combo
          separator = "➜", -- Default: '➜', symbol used between a key and it's label
          group = "🌴 ", -- Default: '+', symbol prepended to a group
        },
        -- your configuration comes here
        -- or leave it empty to use the default settings
        -- refer to the configuration section https://github.com/folke/which-key.nvim#%EF%B8%8F-configuration
    }
end

-- Return Module
return M
