local M = {}

function M.toggle()
    vim.opt.list = not vim.opt.list:get()
end

function M.show()
    vim.opt.list = true
end

function M.hide()
    vim.opt.list = false
end

-- hl-NonText       :highlight NonText ctermfg=7 gui=italic guifg=#696969
-- hl-WhiteSpace    :highlight WhiteSpace ctermfg=7 gui=italic guifg=#696969 -- handles  "nbsp", "space", "tab" and "trail"

function applyConfig(config)
    vim.opt.list = config.list
    vim.opt.listchars = config.listchars
    vim.wo.fillchars= config.fillchars
end

-- http://www.unicode.org/charts/
function M.default()
    return {
        list = true,
        listchars = {
            next = listchars,
            eol = '↵',
            nbsp = '␣',
            tab = '⎯⎯⮞',
            trail = '·',
            extends = '▶',
            precedes = '◀',
            space = '·',
            },
        fillchars = 'eob: ',
    }
end

function M.setup(config)
    config = config or M.default()
    applyConfig(config)
end

return M
