-- Module
local M = {}

local key_binding

M.default_config = function()
    return {
        on_attach = key_binding,
        current_line_blame = true,
        current_line_blame_formatter = '<author>, <author_time:%Y-%m-%d> <summary>',
        current_line_blame_opts = {
            virt_text = true, -- Default: true
            virt_text_pos = 'eol', -- Default: eol, 'eol' | 'overlay' | 'right_align'
            delay = 1000, -- Default: 1000
            ignore_whitespace = false, -- Default: false
        },
        -- signs = {
        --     add          = {hl = 'GitSignsAdd'   , text = '➕', numhl='GitSignsAddNr'   , linehl='GitSignsAddLn'},
        --     change       = {hl = 'GitSignsChange', text = '│', numhl='GitSignsChangeNr', linehl='GitSignsChangeLn'},
        --     delete       = {hl = 'GitSignsDelete', text = '➖', numhl='GitSignsDeleteNr', linehl='GitSignsDeleteLn'},
        --     topdelete    = {hl = 'GitSignsDelete', text = '‾', numhl='GitSignsDeleteNr', linehl='GitSignsDeleteLn'},
        --     changedelete = {hl = 'GitSignsChange', text = '~', numhl='GitSignsChangeNr', linehl='GitSignsChangeLn'},
        -- },
    }
end

M.setup = function(config)
    config = vim.tbl_deep_extend("force", M.default_config(), config or {})

    require('gitsigns').setup(config)
end

key_binding = function(bufnr)
    local gs = package.loaded.gitsigns

    local m = require('constants.vim-mode')
    local wk = require('which-key')

    wk.add(
        {
            { "<leader>g", group = "Git" },
            { "<leader>g]c", "<cmd>Gitsigns stage_hunk<cr>", desc = "🍃 Stage hunk" },
            { "<leader>g[c", "<cmd>Gitsigns reset_hunk<cr>", desc = "🍃 Reset hunk" },
            { "<leader>gS", "<cmd>Gitsigns stage_buffer<cr>", desc = "🍃 Stage buffer" },
            { "<leader>gs", "<cmd>Gitsigns stage_hunk({vim.fn.line('.'), vim.fn.line('v')})<cr>", desc = "🍃 Stage line" },
            { "<leader>gu", "<cmd>Gitsigns undo_stage_hunk<cr>", desc = "🍃 Undo stage hunk" },
            { "<leader>gR", "<cmd>Gitsigns reset_buffer<cr>", desc = "🍃 Reset buffer" },
            { "<leader>gp", "<cmd>Gitsigns preview_hunk<cr>", desc = "🍃 Preview hunk" },
            { "<leader>gb", function() gs.blame_line{full=true} end, desc = "🍃 Blame line" },
            { "<leader>gd", "<cmd>Gitsigns diffthis<cr>", desc = "🍃 Diff this" },
            { "<leader>gD", function() gs.diffthis("~") end, desc = "🍃 Diff vs latest commit" },
            { "<leader>gd", "<cmd>Gitsigns toggle_deleted<cr>", desc = "🍃 Toggle deleted" },
            { "<leader>gb", "<cmd>Gitsigns toggle_current_line_blame<cr>", desc = "🍃 Toggle blame line" },
        }
    );

  wk.add(
        {
            g = {
                name = 'Git',
                ['s'] = { '<cmd>lua require("gitsigns").stage_hunk({vim.fn.line("."), vim.fn.line("v")})<cr>',    '🍃 Stage line ranged'},
            },
        },
        {
            prefix = '<leader>',
            mode = m.visual,
            buffer = bufnr,
        }
  );

  wk.add(
        {
            g = {
                ['ih'] = {'<cmd><C-U>Gitsigns select_hunk<cr>',                                                   '🍃 Select hunk'},
            },
        },
        {
            prefix = '<leader>',
            mode = 'o',
            buffer = bufnr,
        }
  );
end

-- Return Module
return M
