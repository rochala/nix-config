vim.cmd([[augroup lsp]])
vim.cmd([[autocmd!]])
vim.cmd([[autocmd FileType scala setlocal omnifunc=v:lua.vim.lsp.omnifunc]])

vim.cmd([[autocmd FileType scala,sbt,java lua require("metals").initialize_or_attach(Metals_config)]])
vim.cmd([[augroup END]])
vim.cmd([[command! Format lua vim.lsp.buf.formatting()]])

-- YANK highlight
vim.cmd([[autocmd TextYankPost * silent! lua vim.highlight.on_yank {}]])

-- Remove trailing whitespaces
vim.cmd([[autocmd BufWritePre *.scala :%s/\s\+$//e]])

vim.cmd([[augroup file_fix
  autocmd!
    autocmd BufEnter,BufWinEnter,TabEnter *.rs :lua require'lsp_extensions'.inlay_hints{}
  augroup END
]])
