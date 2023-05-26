local cmd = vim.cmd

require'kanagawa'.setup{
  colors = {
    theme = { all = { ui = { bg_gutter = 'none' }  }}
  },
  overrides = function(colors)
      local theme = colors.theme
      return {
          TelescopeTitle = { fg = theme.ui.special, bold = true },
          TelescopePromptNormal = { bg = theme.ui.bg_p1 },
          TelescopePromptBorder = { fg = theme.ui.bg_p1, bg = theme.ui.bg_p1 },
          TelescopeResultsNormal = { fg = theme.ui.fg_dim, bg = theme.ui.bg_m1 },
          TelescopeResultsBorder = { fg = theme.ui.bg_m1, bg = theme.ui.bg_m1 },
          TelescopePreviewNormal = { bg = theme.ui.bg_dim },
          TelescopePreviewBorder = { bg = theme.ui.bg_dim, fg = theme.ui.bg_dim },
          NormalFloat = { fg = theme.ui.shade0, bg = theme.ui.bg_p1 },
          Pmenu = { fg = theme.ui.shade0, bg = theme.ui.bg_p1 },
          PmenuSel = { fg = "NONE", bg = theme.ui.bg_p2 },
          PmenuSbar = { bg = theme.ui.bg_m1 },
          PmenuThumb = { bg = theme.ui.bg_p2 },
      }
  end,
}

cmd("colorscheme kanagawa")
cmd([[hi! Comment cterm=italic gui=italic]])
cmd([[hi! ColorColumn ctermbg=red ]])

-- Statusline specific highlights
-- cmd([[hi! StatusLine guifg=#5C6370 guibg=#282c34]])

local kanagawa_colors = require("kanagawa.colors").setup()

cmd(string.format([[hi! StatusLine guifg=%s guibg=%s]], kanagawa_colors.palette.fujiGray, kanagawa_colors.palette.sumiInk1))
cmd(string.format([[hi! StatusLine guifg=%s guibg=%s]], kanagawa_colors.palette.fujiGray, "#1F1F27"))
cmd(string.format([[hi! LspInlayHint guifg=%s guibg=none ]], kanagawa_colors.palette.fujiGray))


