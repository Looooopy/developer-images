-- [[ Git Signs Setup ]]

require('gitsigns').setup({
    current_line_blame = true,
    current_line_blame_formatter = '<author>, <author_time:%Y-%m-%d> <summary>',
    current_line_blame_opts = {
        virt_text = true, -- Default: true
        virt_text_pos = 'eol', -- Default: eol, 'eol' | 'overlay' | 'right_align'
        delay = 1000, -- Default: 1000
        ignore_whitespace = false, -- Default: false
    },
    on_attach = function(bufnr)
      local gs = package.loaded.gitsigns

      local m = require('constants.vim-mode')
      local wk = require('which-key')

      wk.register(
        {
            g = {
                name = 'Git',
                [']c'] = {'<cmd>Gitsigns stage_hunk<cr>',                                                                   '🍃 Stage hunk'},
                ['[c'] = {'<cmd>Gitsigns reset_hunk<cr>',                                                                   '🍃 Reset hunk'},

                ['S'] = { '<cmd>lua require("gitsigns").stage_buffer()<cr>',                                                '🍃 Stage buffer'},
                ['s'] = { '<cmd>lua require("gitsigns").stage_hunk({vim.fn.line("."), vim.fn.line(".")})<cr>',              '🍃 Stage line'},
                ['u'] = { '<cmd>lua require("gitsigns").undo_stage_hunk()<cr>',                                             '🍃 Undo stage hunk'},
                ['R'] = { '<cmd>lua require("gitsigns").reset_buffer()<cr>',                                                '🍃 Reset buffer'},
                ['p'] = { '<cmd>lua require("gitsigns").preview_hunk()<cr>',                                                '🍃 Preview hunk'},
                ['b'] = { function() require("gitsigns").blame_line{full=true} end,                                         '🍃 Blame line'},
                ['d'] = { '<cmd>lua require("gitsigns").diffthis()<cr>',                                                    '🍃 Diff this'},
                ['D'] = { function() require("gitsigns").diffthis("~") end,                                                 '🍃 Diff vs latest commit'},
                ['d'] = { '<cmd>lua require("gitsigns").toggle_deleted()<cr>',                                              '🍃 Toggle deleted'},
                ['b'] = { '<cmd>lua require("gitsigns").toggle_current_line_blame()<cr>',                                   '🍃 Toggle blame line'},
            },
        },
        {
            prefix = '<leader>',
            mode = m.normal,
            buffer = bufnr,
        }
    );

    wk.register(
        {
            g = {
                name = 'Git',
                ['s'] = { '<cmd>lua require("gitsigns").stage_hunk({vim.fn.line("."), vim.fn.line("v")})<cr>',              '🍃 Stage line ranged'},
            },
        },
        {
            prefix = '<leader>',
            mode = m.visual,
            buffer = bufnr,
        }
    );

    wk.register(
        {
            g = {
                ['ih'] = {'<cmd><C-U>Gitsigns select_hunk<cr>',                                                             '🍃 Select hunk'},
            },
        },
        {
            prefix = '<leader>',
            mode = 'o',
            buffer = bufnr,
        }
    );
    end
})
