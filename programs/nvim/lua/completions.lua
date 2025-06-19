local cmp = require'cmp'
local compare = require('cmp.config.compare')
local cond = require("nvim-autopairs.conds")

local misc = require('cmp.utils.misc')
local str = require('cmp.utils.str')
local types = require('cmp.types')

require('nvim-web-devicons').setup()

local npairs = require('nvim-autopairs')
npairs.setup()
local Rule = require('nvim-autopairs.rule')
npairs.add_rule(Rule('"', '"')
  :with_pair(cond.not_after_text('""')))

local md_namespace = vim.api.nvim_create_namespace 'rochala/lsp_float'

--- Adds extra inline highlights to the given buffer.
---@param buf integer
local function add_inline_highlights(buf)
    for l, line in ipairs(vim.api.nvim_buf_get_lines(buf, 0, -1, false)) do
        for pattern, hl_group in pairs {
            ['@%S+'] = '@keyword',
            ['^%*?%*?%s*(Parameters?:?)'] = '@text.title',
            ['^%*?%*?%s*(Returns?:?)'] = '@text.title',
            ['^%*?%*?%s*(See also:)'] = '@text.title',
            ['{%S-}'] = '@variable.member',
            ['|%S-|'] = '@text.reference',
        } do
            local from = 1 ---@type integer?
            while from do
                local to
                from, to = line:find(pattern, from)
                if from then
                    vim.api.nvim_buf_set_extmark(buf, md_namespace, l - 1, from - 1, {
                        end_col = to,
                        hl_group = hl_group,
                    })
                end
                from = to and to + 1 or nil
            end
        end
    end
end


--- HACK: Override `vim.lsp.util.stylize_markdown` to use Treesitter.
---@param bufnr integer
---@param contents string[]
---@param opts table
---@return string[]
---@diagnostic disable-next-line: duplicate-set-field
vim.lsp.util.stylize_markdown = function(bufnr, contents, opts)
    local hl = contents.hl

    contents = vim.lsp.util._normalize_markdown(contents, {
        width = vim.lsp.util._make_floating_popup_size(contents, opts),
    })
    vim.bo[bufnr].filetype = 'markdown'
    vim.treesitter.start(bufnr)
    vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, contents)

    if hl then
        vim.api.nvim_buf_add_highlight(bufnr, -1, 'LspSignatureActiveParameter', 1, unpack(hl))
    end

    add_inline_highlights(bufnr)

    return contents
end


-- Override the documentation handler to remove the redundant detail section.
---@diagnostic disable-next-line: duplicate-set-field
require('cmp.entry').get_documentation = function(self)
  local item = self:get_completion_item()

  local documents = {}

  -- detail
  if item.detail and item.detail ~= '' then
    local ft = self.context.filetype
    local dot_index = string.find(ft, '%.')
    if dot_index ~= nil then
      ft = string.sub(ft, 0, dot_index - 1)
    end
    table.insert(documents, {
      kind = types.lsp.MarkupKind.Markdown,
      value = ('```%s\n%s\n```'):format(ft, str.trim(item.detail)),
    })
  end

  local documentation = item.documentation
  if type(documentation) == 'string' and documentation ~= '' then
    local value = str.trim(documentation)
    if value ~= '' then
      table.insert(documents, {
        kind = types.lsp.MarkupKind.PlainText,
        value = value,
      })
    end
  elseif type(documentation) == 'table' and not misc.empty(documentation.value) then
    local value = str.trim(documentation.value)
    if value ~= '' then
      table.insert(documents, {
        kind = documentation.kind,
        value = value,
      })
    end
  end

  local res = vim.lsp.util.convert_input_to_markdown_lines(documents)

  if item.documentation and item.documentation.hl then
      res.hl = item.documentation.hl
  end

  return res
end

local cmp_kinds = {
  Text = ' ',
  Method = ' ',
  Function = ' ',
  Constructor = ' ',
  Field = ' ',
  Variable = ' ',
  Class = ' ',
  Interface = ' ',
  Module = ' ',
  Property = ' ',
  Unit = ' ',
  Value = ' ',
  Enum = ' ',
  Keyword = ' ',
  Snippet = ' ',
  Color = ' ',
  File = ' ',
  Reference = ' ',
  Folder = ' ',
  EnumMember = ' ',
  Constant = ' ',
  Struct = ' ',
  Event = ' ',
  Operator = ' ',
  TypeParameter = ' ',
}

-- local cmp_autopairs = require('nvim-autopairs.completion.cmp')

-- require("lspkind").init({
-- 	mode = "text_symbol",
--   preset = 'codicons',
-- })

-- vim.g.copilot_assume_mapped = true
-- vim.g.copilot_no_tab_map = true

-- require("sg").setup()

-- cmp.event:on( 'confirm_done', cmp_autopairs.on_confirm_done({  map_char = { scala = '' }, map_complete = false }))
cmp.setup({
  snippet = {
    expand = function(args)
      -- Comes from vsnip
      vim.fn["vsnip#anonymous"](args.body)
    end,
  },
  formatting = {
    expandable_indicator = true,
    fields = { 'abbr', 'kind', 'menu' },
    format = function(_, vim_item)
      vim_item.kind = (cmp_kinds[vim_item.kind] or '') .. vim_item.kind
      return vim_item
    end,
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
    completeopt = 'menu,menuone,noinsert',
  },
  experimental = {
    ghost_text = false,
  },
  mapping = {
  -- None of this made sense to me when first looking into this since there
  -- is no vim docs, but you can't have select = true here _unless_ you are
  -- also using the snippet stuff. So keep in mind that if you remove
  -- snippets you need to remove this select
      ["<CR>"] = cmp.mapping.confirm({ select = true, behavior = cmp.ConfirmBehavior.Insert, }),
      ["<Tab>"] = function(fallback)
        if cmp.visible() then
          cmp.select_next_item({ behavior = cmp.SelectBehavior.Insert })
        else
          fallback()
        end
      end,
      ["<S-Tab>"] = function(fallback)
        if cmp.visible() then
          cmp.select_prev_item({ behavior = cmp.SelectBehavior.Insert })
        else
          fallback()
        end
      end,
      ["<Down>"] = function(fallback)
        if cmp.visible() then
          cmp.select_next_item({ behavior = cmp.SelectBehavior.Insert })
        else
          fallback()
        end
      end,
      ["<Up>"] = function(fallback)
        if cmp.visible() then
          cmp.select_prev_item({ behavior = cmp.SelectBehavior.Insert })
        else
          fallback()
        end
      end,
      ["<right>"] = function(fallback)
        -- local copilot_keys = vim.fn["copilot#Accept"]()
        require("copilot.suggestion").accept()
        -- if copilot_keys ~= "" then
        --   vim.api.nvim_feedkeys(copilot_keys, "i", true)
        -- else
        --   fallback()
        -- end
      end,
  },
  sources = {
      { name = 'nvim_lsp', priority = 10 },
      { name = 'cody' },
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

-- COPILOT
require("copilot").setup {
  suggestion = {
    enabled = true,
    auto_trigger = true,
  },
  filetypes = {
    scala = true, -- allow specific filetype
    ["*"] = false, -- disable for all other filetypes and ignore default `filetypes`
  },
}

-- Copilot chat
local chat = require('CopilotChat')
local actions = require('CopilotChat.actions')
local select = require('CopilotChat.select')

chat.setup({
    model = 'claude-3.5-sonnet',
    selection = select.visual,
    sticky = {
        '/COPILOT_GENERATE',
        '#buffers'
    },
    mappings = {
        reset = {
            normal = '',
            insert = '',
        },
        show_diff = {
            full_diff = true,
        }
    },
    prompts = {
        Explain = {
            mapping = '<leader>ae',
            description = 'AI Explain',
        },
        Review = {
            mapping = '<leader>ar',
            description = 'AI Review',
        },
        Tests = {
            mapping = '<leader>at',
            description = 'AI Tests',
        },
        Fix = {
            mapping = '<leader>af',
            description = 'AI Fix',
        },
        Optimize = {
            mapping = '<leader>ao',
            description = 'AI Optimize',
        },
        Docs = {
            mapping = '<leader>ad',
            description = 'AI Documentation',
        },
        Commit = {
            mapping = '<leader>ac',
            description = 'AI Generate Commit',
        },
    },
})

vim.keymap.set({ 'n' }, '<leader>aa', chat.toggle, { desc = 'AI Toggle' })
vim.keymap.set({ 'v' }, '<leader>aa', chat.open, { desc = 'AI Open' })
vim.keymap.set({ 'n' }, '<leader>ax', chat.reset, { desc = 'AI Reset' })
vim.keymap.set({ 'n' }, '<leader>as', chat.stop, { desc = 'AI Stop' })
vim.keymap.set({ 'n' }, '<leader>am', chat.select_model, { desc = 'AI Model' })
vim.keymap.set({ 'n', 'v' }, '<leader>aq', function()
    vim.ui.input({
        prompt = 'AI Question> ',
    }, function(input)
        if input and input ~= '' then
            chat.ask(input)
        end
    end)
end, { desc = 'AI Question' })
