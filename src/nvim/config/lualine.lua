-- [[ Lualine Setup - https://github.com/hoob3rt/lualine.nvim ]]

-- Lualine has sections as shown below.
-- +-------------------------------------------------+
-- | A | B | C                             X | Y | Z |
-- +-------------------------------------------------+
-- Each sections holds it's components e.g. current vim's mode.
-- Custom Lualine https://gist.github.com/hoob3rt/b200435a765ca18f09f83580a606b878

require('lualine').setup {
    options = {
        theme = 'gruvbox-material',
        icons_enabled = true,
        component_separators = {'', ''},
        section_separators = {'', ''},
        disabled_filetypes = {}
    }, 
    sections = {
        lualine_a = {'mode'},
        lualine_b = {'branch'},
        lualine_c = {'filename'},
        lualine_x = {'encoding', 'fileformat', 'filetype'},
        lualine_y = {'progress'},
        lualine_z = {'location'}
    }, 
    inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {'filename'},
        lualine_x = {'location'},
        lualine_y = {},
        lualine_z = {}
    }, 
    tabline = {},
    extensions = {}
} 

-- [[ Available Commands ]]

-- NONE
-- Read more about it
-- :help lualine
