-- Module
local M = {}

--------------------------------
-- Forward function declarations
--------------------------------
local bind_keys
local register_commands
local highlight_auto_cmd

local _config

local dependency = require('common.dependency')

----------------------------
-- Public function interface
----------------------------
M.setup = function(config)
    _config = vim.tbl_deep_extend("force", M.default_config(), config or {})

    local capabilities = vim.lsp.protocol.make_client_capabilities()
    local ok, cmp_nvim_lsp = dependency.require('cmp_nvim_lsp')
    if not ok then
        return
    end

    require('lsp_signature').setup(
        {
            bind = true,
            handler_opts = {
                border = "rounded",
            },
        }
    )

    -- Add symbols as in folke/trouble.nvim
    vim.fn.sign_define('DiagnosticSignError', { text = "", texthl = "DiagnosticSignError" })
    vim.fn.sign_define('DiagnosticSignWarn', { text = "", texthl = "DiagnosticSignWarn" })
    vim.fn.sign_define('DiagnosticSignInfo', { text = "", texthl = "DiagnosticSignInfo" })
    vim.fn.sign_define('DiagnosticSignHint', { text = "", texthl = "DiagnosticSignHint" })

    vim.diagnostic.config(_config.diagnostic);

    require('trouble').setup()

    -- Hook up completion engine with language server
    M.capabilities = cmp_nvim_lsp.update_capabilities(capabilities)
end

M.default_config = function()
    return {
        -- https://github.com/neovim/neovim/blob/master/runtime/lua/vim/diagnostic.lua#L555-L597
        diagnostic = {
            update_in_insert = true,
            severity_sort = false,
            underline = true,
            virtual_text = true,
            signs = true,
            float = { border = "rounded" }
        }
    }
end

M.attach = function(client, bufnr)
    local capabilities = client.server.capabilities
    -- if client.name == "tsserver" then
    --     capabilities.document_formatting = false
    -- end

    bind_keys(bufnr)

    if capabilities.document_highlight then
        highlight_auto_cmd(client)
    end
end

M.process_id_nil = function(params)
    params.processId = vim.NIL
end

--------------------
-- Private functions
--------------------
bind_keys = function(bufnr)
    local m = require('constants.vim-mode')
    local wk = require('which-key')
    wk.register(
        {
            g = {
                name = 'Goto',
                d = { vim.lsp.buf.definition, '🍃 Definition (Goto)' },
                T = { vim.lsp.buf.type_definition, '🍃 Type definition (Goto)' },
                i = { vim.lsp.buf.implementation, '🍃 Implementation (Goto)' },
                r = { vim.lsp.buf.references, '🍃 References (Goto)' },
                l = { '<cmd>Telescope lsp_references<cr>', '🍃 List References (Goto)' },
            },
            d = {
                name = 'Diagnostics',
                j = { '<cmd>lua vim.diagnostic.goto_next()<cr>','🍃 Next Diagnostics' },
                k = { '<cmd>lua vim.diagnostic.goto_prev()<cr>', '🍃 Prev diagnostics' },
                h = { '<cmd>lua vim.diagnostic.open_float()<cr>', '🍃 Line diagnostic' },
                l = { '<cmd>Telescope diagnostics<cr>', '🍃 Full, List diagnostic in project' },
                t = { '<cmd>TroubleToggle<cr>', '🍃 Qfix, List diagnostic in project' },
            },
            r = {
                name = 'Refactor',
                r = { vim.lsp.buf.rename, '🍃 Rename (Refactor)' },
                c = { vim.lsp.buf.code_action, '🍃 Code Action (Refactor)' },
                f = { vim.lsp.buf.formatting, '🍃 Format (Refactor)' },
            }
        },
        {
            mode = m.normal,
            buffer = bufnr,
        }
    )
end

register_commands = function()
    vim.cmd [[ command! Format Execute `lua vim.lsp.buf.formatting()` ]]
end

highlight_auto_cmd = function()
    vim.api.nvim_exec(
        [[
        augroup lsp_document_highlight
            autocmd! * <buffer>
            autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
            autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
        augroup END
        ]],
        false
    )
end

-- Return Module
return M
