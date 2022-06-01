local cmd = vim.cmd

cmd("colorscheme kanagawa")
cmd([[hi! Comment cterm=italic gui=italic]])
cmd([[hi! ColorColumn ctermbg=0 ]])

-- Statusline specific highlights
cmd([[hi! StatusLine guifg=#5C6370 guibg=#282c34]])

