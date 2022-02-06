local wk = require('which-key')
local m = require('constants.vim-mode')
local b = require('constants.buffer')

vim.opt.completeopt= { 'menu', 'menuone', 'noselect' }

local cmp = require('cmp')
cmp.setup({
  snippet = {
    expand = function(args)
      --vim.fn['vsnip#anonymous'](args.body)
      require('luasnip').lsp_expand(args.body)
    end,
  },
  mapping = {
    ['<Tab>'] = cmp.mapping(cmp.mapping.select_next_item(), {m.insert, m.cmd_edit}),
    ['<S-Tab>'] = cmp.mapping(cmp.mapping.select_prev_item(), {m.insert, m.cmd_edit}),
    ['<C-b>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), {m.insert, m.cmd_edit}),
    ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), {m.insert, m.cmd_edit}),
    ['<C-y>'] = cmp.config.disable,
    ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), {m.insert, m.cmd_edit}),
    ['<C-e>'] = cmp.mapping({
      i = cmp.mapping.abort(),
      c = cmp.mapping.close(),
    }),
    ['<CR>'] = cmp.mapping.confirm({select = true}),
  },
  sources = {
    { name = 'nvim_lsp' },
    { name = 'vsnip' },
    { name = 'buffer' },
  }
})