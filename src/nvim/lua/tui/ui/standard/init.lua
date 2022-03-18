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
        git = require('tui.ui.standard.git').default_config(),
        top_line = require('tui.ui.standard.top-line').default_config(),
        onscreen_shortcut = require('tui.ui.standard.onscreen-shortcut').default_config(),
        show_colored_codes = require('tui.ui.standard.show-colored-codes').default_config(),
        syntax_highlighting = require('tui.ui.standard.syntax-highlighting').default_config(),
    }
end

M.setup = function(config)
    config = vim.tbl_deep_extend("force", M.default_config(), config or {})

    require('tui.ui.standard.onscreen-shortcut').setup(config.onscreen_shortcut)
    require('tui.ui.standard.show-colored-codes').setup(config.show_colored_codes)
    require('tui.ui.standard.top-line').setup(config.top_line)
    require('tui.ui.standard.statusline').setup(config.statusline)
    require('tui.ui.standard.git').setup(config.git)
    require('tui.ui.standard.syntax-highlighting').setup(config.syntax_highlighting)
end

-- Return Module
return M
