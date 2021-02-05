if exists('g:loaded_lspupdate') | finish | endif

com! -nargs=? LspUpdate lua require'lspupdate'(<f-args>)

let g:loaded_lspupdate = 1
