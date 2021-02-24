func! health#lspupdate#check()
  lua require'lspupdate.health'(require'lspupdate.config')
endf
