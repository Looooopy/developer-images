-- MAIN Module
local M = {}

M.default_config = function()
    return {
        ui = require('tui.ui.module').default_config(),
        data = require('tui.data.module').default_config(),
    }
end

M.setup = function(config)
    config = vim.tbl_deep_extend("force", M.default_config(), config or {})

    require('tui.ui.module').setup(config.visability)
    require('tui.data.module').setup(config.standard)

    require("trouble").setup({})
    -- local null_ls = require("null-ls")

    -- null_ls.setup {
    --     sources = {
    --         null_ls.builtins.code_actions.gitsigns,
    --     }
    -- }
end

-- Return MAIN Module
return M
