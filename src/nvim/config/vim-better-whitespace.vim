" [[ Vim-better-whitespace Setup ]]

"highlight ExtraWhitespace ctermbg=<desired_color>
" or
"let g:better_whitespace_ctermcolor='<desired_color>'
let g:better_whitespace_filetypes_blacklist=['<filetype1>', '<filetype2>', '<etc>','diff', 'git', 'gitcommit', 'unite', 'qf', 'help', 'markdown', 'fugitive']


" [[ Available Commands ]]

" Check if some commands has changed
" :help better-whitespace-commands

" ToggleWhitespace
" EnableWhitespace
" DisableWhitespace
" NextTrailingWhitespace
" PrevTrailingWhitespace
" StripWhitespace[!]
