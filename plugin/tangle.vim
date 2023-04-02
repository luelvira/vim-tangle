" Title: vim-tangle
" Description: Tangle code from markdown files to another file
" Last Change: 2023-04-02
" Maintainer: <https://github.com/luelvira>
" License: MIT

" Prevent the plugin from being loaded twice
if exists('g:loaded_tangle')
  finish
endif
let g:loaded_tangle = 1

" Expose the plugin's function for use as a command in vim only if the
" filetype is markdown

command! -nargs=0 Tangle call tangle#Tangle()
command! -nargs=1 TangleAdd call tangle#TangleAdd(<f-args>)
command! -nargs=0 TangleRemove call tangle#TangleRemove()
