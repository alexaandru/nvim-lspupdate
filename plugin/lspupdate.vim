if exists('g:loaded_lspupdate') | finish | endif

com! -bar LspUpdate lua require'lspupdate'.LspUpdate()
