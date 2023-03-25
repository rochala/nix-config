local cmp = require'cmp'
local compare = require('cmp.config.compare')
local lspkind = require('lspkind')
local cond = require("nvim-autopairs.conds")
local npairs = require('nvim-autopairs')
npairs.setup()
local Rule = require('nvim-autopairs.rule')
npairs.add_rule(Rule('"', '"')
  :with_pair(cond.not_after_text('""')))

-- local cmp_autopairs = require('nvim-autopairs.completion.cmp')

require("lspkind").init({
	mode = "text_symbol",
  preset = 'codicons',
})

-- cmp.event:on( 'confirm_done', cmp_autopairs.on_confirm_done({  map_char = { scala = '' }, map_complete = false }))
cmp.setup({
  snippet = {
    expand = function(args)
      -- Comes from vsnip
      vim.fn["vsnip#anonymous"](args.body)
    end,
  },
  formatting = {
    format = lspkind.cmp_format {
      maxwidth = 50,
      with_text = true,
      menu = {
        nvim_lsp = "[LSP]",
        buffer = "[Buf]",
        path = "[Path]",
      },
    },
  },
  preselect = cmp.PreselectMode.None,
  sorting = {
    priority_weight = 2,
    comparators = {
      compare.offset,
      compare.score,
      compare.sort_text,
      compare.recently_used,
      compare.kind,
      compare.length,
      compare.order,
    },
  },
  completion = {
    completeopt = 'menu,menuone',
  },
  mapping = {
  -- None of this made sense to me when first looking into this since there
  -- is no vim docs, but you can't have select = true here _unless_ you are
  -- also using the snippet stuff. So keep in mind that if you remove
  -- snippets you need to remove this select
      ["<CR>"] = cmp.mapping.confirm({ select = true, behavior = cmp.ConfirmBehavior.Insert, }),
      ["<Tab>"] = function(fallback)
        if cmp.visible() then
          cmp.select_next_item()
        else
          fallback()
        end
      end,
      ["<S-Tab>"] = function(fallback)
        if cmp.visible() then
          cmp.select_prev_item()
        else
          fallback()
        end
      end,
      ["<Down>"] = function(fallback)
        if cmp.visible() then
          cmp.select_next_item()
        else
          fallback()
        end
      end,
      ["<Up>"] = function(fallback)
        if cmp.visible() then
          cmp.select_prev_item()
        else
          fallback()
        end
      end,
  },
  sources = {
      { name = 'nvim_lsp', priority = 10 },
      { name = 'buffer', max_item_count = 10 },
      { name = 'path' },
      { name = "vsnip" },
      { name = 'nvim_lsp_signature_help' },
  },

})

cmp.setup.cmdline(':', {
    completion = { autocomplete = false },
    sources = cmp.config.sources(
      { name = 'path' },
      { name = 'cmdline' }
    )
})

cmp.setup.cmdline('/', {
    completion = { autocomplete = false },
    sources = {
      { name = 'buffer' },
      { name = 'path' }
    }
  })
