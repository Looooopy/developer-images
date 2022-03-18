-- Module
local M = {}

--------------------------------
-- Dependencies
--------------------------------
local dependency = require('common.dependency')
local required = {
    -- External
    'cmp',
    'luasnip',
    'which-key',
    'lspkind',
    -- Internal
    'constants.buffer',
    'constants.vim-mode',
}

local all_ok, depencencies = dependency.require_all(required)
if not all_ok then
    return
end

local cmp = depencencies[1]
local luasnip = depencencies[2]
local wk = depencencies[3]
local lspkind = depencencies[4]
local b = depencencies[5]
local m = depencencies[6]

--------------------------------
-- Forward function declarations
--------------------------------
local bind_keys
local register_commands
local _config

----------------------------
-- Public function interface
----------------------------
M.setup = function(config)
    _config = vim.tbl_deep_extend("force", M.default_config(), config or {})

    if not all_ok then
        return
    end

    local lspkind = require('lspkind')

    cmp.setup(_config.global)
    -- wk.register(_config.which_key,
    --     {
    --         mode = m.normal,
    --         buffer = b.all_buffers,
    --     })

    cmp.setup.cmdline('/', _config.cmdline_slash)
    -- cmp.setup.cmdline(':', _config.cmdline_colon)
end


M.default_config = function()
    if not all_ok then
        return {}
    end

    return
    {
        which_key = {
            ['<Tab>'] =     { cmp.mapping(cmp.mapping.select_next_item()),                      '🍃 Next item (Completion)' },
            ['<S-Tab>'] =   { cmp.mapping(cmp.mapping.select_prev_item()),                      '🍃 Prev item (Completion)' },
            ['<C-b>'] =     { cmp.mapping(cmp.mapping.scroll_docs(-4)),                         '🍃 Scroll Up (Completion)' },
            ['<C-f>'] =     { cmp.mapping(cmp.mapping.scroll_docs(4), {m.insert, m.cmd}),  '🍃 Scroll Dowm (Completion)' },
            ['<C-y>'] =     { cmp.config.disable,                                               '🍃 Disable (Completion)' },
            ['<C-Space>'] = { cmp.mapping(cmp.mapping.complete(), {m.insert, m.cmd}),      '🍃 Complete (Completion)' },
            ['<C-e>'] =     { cmp.mapping({ i = cmp.mapping.abort(), c = cmp.mapping.close()}), '🍃 Abort (Completion)' },
            ['<CR>'] =      { cmp.mapping.confirm({select = true}),                             '🍃 Confirm (Completion)' },
        },
        global = {
            formatting = {
                format = lspkind.cmp_format(
                    {
                        mode = 'symbol', -- show only symbol annotations
                        maxwidth = 50, -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
                        -- The function below will be called before any actual modifications from lspkind
                        -- so that you can provide more controls on popup customization. (See [#30](https://github.com/onsails/lspkind-nvim/pull/30))
                        before = function (entry, vim_item)
                            return vim_item
                        end
                    }
                )
            },
            snippet = {
                expand = function(args)
                    -- vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
                    luasnip.lsp_expand(args.body) -- For `luasnip` users.
                    -- require'snippy'.expand_snippet(args.body) -- For `snippy` users.
                    -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
                end,
            },
            mapping = {
                ['<Tab>'] = cmp.mapping(cmp.mapping.select_next_item(), {m.insert, m.cmd}),
                ['<S-Tab>'] = cmp.mapping(cmp.mapping.select_prev_item(), {m.insert, m.cmd}),
                ['<C-b>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), {m.insert, m.cmd}),
                ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), {m.insert, m.cmd}),
                ['<C-y>'] = cmp.config.disable,
                ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), {m.insert, m.cmd}),
                ['<C-e>'] = cmp.mapping({
                    i = cmp.mapping.abort(),
                    c = cmp.mapping.close(),
                }),
                ['<CR>'] = cmp.mapping.confirm({select = true}),
            },
            sources = cmp.config.sources(
                {
                    { name = 'nvim_lsp' },
                    -- { name = 'vsnip' }, -- For vsnip users.
                    { name = 'luasnip' }, -- For luasnip users.
                    -- { name = 'snippy' }, -- For snippy users.
                    -- { name = 'ultisnips' }, -- For ultisnips users.
                },
                {
                    { name = 'buffer' },
                }
            )
        },
        cmdline_slash = {
            sources = {
                { name = 'buffer' }
            }
        },
        cmdline_colon = {
            sources = cmp.config.sources(
                {
                    { name = 'path' }
                },
                {
                    { name = 'cmdline' }
                }
            )
        }
    }
end

-- Return Module
return M
