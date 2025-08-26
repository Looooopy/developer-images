-- Module
local M = {}

M.setup = function(config)
    config = vim.tbl_deep_extend("force", M.default_config(), config or {})
    require('neoclip').setup(config)
    require('telescope').load_extension('neoclip')
    local b = require('constants.buffer')
    local m = require('constants.vim-mode')
    wk = require('which-key')
    wk.add({
                                      { "<leader>c", "<cmd>Telescope neoclip<cr>", desc = "🍃 Clipboard search" }
        }
    )
end

M.default_config = function()
    return {
        history = 1000,
        enable_persistent_history = false,
        continious_sync = false,
        db_path = vim.fn.stdpath("data") .. "/databases/neoclip.sqlite3",
        filter = nil,
        preview = true,
        default_register = '"',
        default_register_macros = 'q',
        enable_macro_history = true,
        content_spec_column = false,
        on_paste = {
          set_reg = false,
        },
        on_replay = {
          set_reg = false,
        },
        keys = {
          telescope = {
            i = {
              select = '<cr>',
              paste = '<c-p>',
              paste_behind = '<c-k>',
              replay = '<c-q>',  -- replay a macro
              delete = '<c-d>',  -- delete an entry
              custom = {},
            },
            n = {
              select = '<cr>',
              paste = 'p',
              paste_behind = 'P',
              replay = 'q',
              delete = 'd',
              custom = {},
            },
          },
          fzf = {
            select = 'default',
            paste = 'ctrl-p',
            paste_behind = 'ctrl-k',
            custom = {},
          },
        },
      }
end

-- Return Module
return M
