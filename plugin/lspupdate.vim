if exists('g:loaded_lspupdate') | finish | endif

com! LspUpdate lua require'lspupdate'()

let g:loaded_lspupdate = 1
