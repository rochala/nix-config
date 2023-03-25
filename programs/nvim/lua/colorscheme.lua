local cmd = vim.cmd

cmd("colorscheme kanagawa")
cmd([[hi! Comment cterm=italic gui=italic]])
cmd([[hi! ColorColumn ctermbg=red ]])

-- Statusline specific highlights
-- cmd([[hi! StatusLine guifg=#5C6370 guibg=#282c34]])
local kanagawa_colors = require("kanagawa.colors").setup()
cmd(string.format([[hi! StatusLine guifg=%s guibg=%s]], kanagawa_colors.palette.fujiGray, kanagawa_colors.palette.sumiInk1))
cmd(string.format([[hi! StatusLine guifg=%s guibg=%s]], kanagawa_colors.palette.fujiGray, "#1F1F27"))

