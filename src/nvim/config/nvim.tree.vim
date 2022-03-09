" [[ Tree Setup ]]

let g:nvim_tree_side = 'right' "left by default
let g:nvim_tree_width = 40 "30 by default, can be width_in_columns or 'width_in_percent%'
let g:nvim_tree_respect_buf_cwd = 1 "0 by default, will change cwd of nvim-tree to that of new buffer's when opening nvim-tree.
let g:nvim_tree_refresh_wait = 500 "1000 by default, control how often the tree can be refreshed, 1000 means the tree can be refresh once per 1000ms.
let g:nvim_tree_special_files = { 'README.md':0 , 'Makefile': 1, 'MAKEFILE': 1 } " List of filenames that gets highlighted with NvimTreeSpecialFile
let g:nvim_tree_show_icons = {
    \ 'git': 1,
    \ 'folders': 1,
    \ 'files': 1,
    \ 'folder_arrows': 1,
    \ }

" [[ Available Commands ]]

" Check if some commands has changed
" :help nvim-tree-commands

" NvimTreeOpen
" NvimTreeClose
" NvimTreeToggle
" NvimTreeFocus
" NvimTreeRefresh
" NvimTreeFindFile
" NvimTreeClipboard
" NvimTreeResize