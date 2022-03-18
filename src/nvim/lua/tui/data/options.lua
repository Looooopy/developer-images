local M = {}

M.default_config = function()
end

M.setup = function(config)
    vim.g.mapleader = ' '       -- Set leader to <Space>

    local options = {
        completeopt = {         -- Prefered by completion-engine (cmp)
            'menu',
            'menuone',
            'noselect',
        },
        conceallevel = 0,        -- Show `` in markdown files
        cursorline = true,       -- Highlight the current line cursor is located on.
        expandtab = true,        -- Convert tabs to spaces
        fileencoding = 'utf-8',  -- Set ned files to UTF8 format
        mouse = 'a',             -- Set use mouse on 'a'll modes (n=normal, v=visual,i=insert, c=command, h=allprevious in help)
        number = true,           -- Print the line number in front of each line
        scrolloff = 8,           -- Keep scrolling (up/down) the document even if we have not reached top/bottom.
        sidescrolloff = 8,       -- Keep scrolling (Left/Right) the document even if we have not reached sides
        showtabline = 2,         -- Show tabs (used by top-line.lua and is set withing that plugin so its not needed)
        signcolumn = 'yes',      -- Always show the sign column to make less impact of things jumping around
        smartcase = true,        -- Smart case
        smartindent = true,      -- Make indenting smarter again
        splitbelow = true,       -- Force all horizontal splits to go below current window
        splitright = true,       -- Force all vertical splits to go to the right of current window
        swapfile = false,        -- Disable swapfiles we use git.
        termguicolors = true,    -- Enabled for colors to be applied correctly
        undofile = true,         -- Enable persistent undo so it would not be dropped when file is saved.
        updatetime = 300,        -- Faster completion (4000ms default)
        wrap = false,            -- default:  true, when false no wrap instead show symbols <Extends> and <Precedes>
    }

    for k, v in pairs(options) do
        vim.opt[k] = v
    end
end

return M
