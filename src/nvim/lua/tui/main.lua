-- MAIN Module
local M = {}

M.default_config = function()
    return {
        ui = require('tui.ui').default_config(),
        data = require('tui.data').default_config(),
    }
end

M.setup = function(config)
    config = vim.tbl_deep_extend("force", M.default_config(), config or {})

    require('tui.data').setup(config.data)
    require('tui.ui').setup(config.ui)

    -- Had to move this to packer bacause the plugins are loaded after init.lua
    -- https://github.com/wbthomason/packer.nvim/issues/554
    -- https://github.com/wbthomason/packer.nvim/pull/402 (Fix in progress)
    --require('tui.ui.colourscheme').random()

    -- require("trouble").setup({})
    -- local null_ls = require("null-ls")

    -- null_ls.setup {
    --     sources = {
    --         null_ls.builtins.code_actions.gitsigns,
    --     }
    -- }
end

-- Return MAIN Module
return M
