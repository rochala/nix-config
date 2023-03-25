local cmd = vim.cmd

-- Sign remap
vim.fn.sign_define("DiagnosticSignError", { text = "▬", texthl = "DiagnosticError" })
vim.fn.sign_define("DiagnosticSignWarn", { text = "▬", texthl = "DiagnosticWarn" })
vim.fn.sign_define("DiagnosticSignInfo", { text = "▬", texthl = "DiagnosticInfo" })
vim.fn.sign_define("DiagnosticSignHint", { text = "▬", texthl = "DiagnosticHint" })

require("indent_blankline").setup({
    char = "⋅",
    filetype_exclude = { "help" },
    show_trailing_blankline_indent = false,
})

require('gitsigns').setup()
require("scrollbar").setup({
  handlers = {
    gitsigns = true
  }
})

cmd([[hi! link StatusError DiagnosticError]])
cmd([[hi! link StatusWarn DiagnosticWarn]])

cmd([[hi! link LspReferenceText CursorColumn]])
cmd([[hi! link LspReferenceRead CursorColumn]])
cmd([[hi! link LspReferenceWrite CursorColumn]])

cmd([[hi! DiagnosticError guifg=#e06c75]])
cmd([[hi! DiagnosticWarn guifg=#e5c07b]])
cmd([[hi! DiagnosticInfo guifg=#56b6c2]])

cmd([[hi! DiagnosticUnderlineError cterm=NONE gui=underline guifg=NONE]])
cmd([[hi! DiagnosticUnderlineWarn cterm=NONE gui=underline guifg=NONE]])
cmd([[hi! DiagnosticUnderlineInfo cterm=NONE gui=underline guifg=NONE]])
cmd([[hi! DiagnosticUnderlineHint cterm=NONE gui=underline guifg=NONE]])
cmd([[hi! link DiagnosticHint DiagnosticInfo]])

cmd([[hi! IndentBlanklineChar guifg=#445060 gui=nocombine]])

cmd([[hi! TelescopeTitle guifg=#e5c07b]])


