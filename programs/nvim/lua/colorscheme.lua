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
          -- update kanagawa to handle new treesitter highlight captures
          -- ["@lsp.typemod.parameter.readonly.scala"] = { link = "@parameter" },
          ["@lsp.type.method.scala"] = { link = "@function" },
          ["@lsp.mod.readonly.scala"] = { link = "@lsp" },
          ["@string.regexp"] = { link = "@string.regex" },
          -- ["@variable.parameter"] = { link = "@parameter" },
          -- ["@exception"] = { link = "@exception" },
          -- ["@string.special.symbol"] = { link = "@symbol" },
          ["@markup.strong"] = { link = "@text.strong" },
          ["@markup.italic"] = { link = "@text.emphasis" },
          ["@markup.heading"] = { link = "@text.title" },
          ["@markup.raw"] = { link = "@text.literal" },
          ["@markup.quote"] = { link = "@text.quote" },
          ["@markup.math"] = { link = "@text.math" },
          ["@markup.environment"] = { link = "@text.environment" },
          ["@markup.environment.name"] = { link = "@text.environment.name" },
          ["@markup.link.url"] = { link = "Special" },
          ["@markup.link.label"] = { link = "Identifier" },
          ["@comment.note"] = { link = "@text.note" },
          ["@comment.warning"] = { link = "@text.warning" },
          ["@comment.danger"] = { link = "@text.danger" },
          ["@diff.plus"] = { link = "@text.diff.add" },
          ["@diff.minus"] = { link = "@text.diff.delete" },
          -- ["@parameter"] = { link = "@variable.parameter" },
          -- ["@field"] = { link = "@variable.member" },
          -- ["@namespace"] = { link = "@module" },
          ["@float"] = { link = "@number.float" },
          ["@symbol"] = { link = "@string.special.symbol" },
          ["@string.regex"]= {link = "@string.regexp" },
          ["@text.title"]= { link = "@markup.heading" },
          ["@text.literal"]= {link = "@markup.raw" },
          ["@text.reference"]= {link = "@markup.link" },
          -- ["@text.uri"]= {link = "@markup.link.url" },
          ["@string.special"]= {link = "@markup.link.label" },
          ["@punctuation.special"]= {link = "@markup.list" },
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


