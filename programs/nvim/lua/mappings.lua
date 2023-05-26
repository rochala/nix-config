local functions = require("functions")
local map = functions.map

require("gitlinker").setup()

map("t", "<C-x>", "<C-\\><C-n>")
map("i", "<C-c>", "<esc>")

map("n", "<leader>h", ":wincmd h<CR>")
map("n", "<leader>j", ":wincmd j<CR>")
map("n", "<leader>k", ":wincmd k<CR>")
map("n", "<leader>l", ":wincmd l<CR>")
map("n", "S-<Tab>", "za")
map("n", "<leader>\\", ":vsp<CR>")
map("n", "<leader>s", ":sp<CR>")

map("v", "K", ":m '<-2<CR>gv=gv")
map("v", "J", ":m '>+1<CR>gv=gv")
map("v", "X", "\"_d")

map("n", "<leader>/", ":so ~/.config/nvim/init.lua<CR>")
map("n", "<leader>[", ":vertical resize +5<CR>")
map("n", "<leader>]", ":vertical resize -5<CR>")


-- inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>" inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>" nnoremap <leader>gc :GBranches<CR> nnoremap <leader>ga :Git fetch --all<CR> nnoremap <leader>grum :Git rebase upstream/master<CR>
-- nnoremap <leader>grom :Git rebase origin/master<CR>
-- nnoremap <leader>ghw :h <C-R>=expand("<cword>")<CR><CR>

map("n", "<leader>pw", ":lua require('telescope.builtin').grep_string({ search = vim.fn.expand('<cword>'), layout_strategy='vertical', layout_config = { width=0.8, height=0.8} })<CR>")
map("n", "<leader>ps", ":lua require('telescope.builtin').grep_string({ search = vim.fn.input('Grep For >'), layout_strategy='vertical', layout_config = { width=0.8, height=0.8} })<CR>")
map("n", "<Leader>pf", ":lua require('telescope.builtin').find_files({layout_strategy='vertical', layout_config = { width=0.8, height=0.8} })<CR>")
map("n", "<Leader>pg", ":lua require('telescope.builtin').git_status({layout_strategy='vertical', layout_config = { width=0.8, height=0.8} })<CR>")
map("n", "<Leader>pb", ":lua require('telescope.builtin').buffers({layout_strategy='vertical', layout_config = { width=0.8, height=0.8} })<CR>")
map("n", "<leader>ph", ":lua require('telescope.builtin').help_tags()<CR>")
map("n", "<leader>pu", ":lua require('telescope').extensions.undo.undo()<CR>")
map("n", "<C-p>", ":lua require('telescope.builtin').git_files()<CR>")

map("n", "<leader>bs", "/<C-R>=escape(expand(\"<cWORD>\"), \"/\")<CR><CR>")

map("n", "<silent>gr", "<cmd>lua require'telescope.builtin'.lsp_references{ shorten_path = true }<CR>")
map("n", "<leader>vd", ":lua require('telescope.builtin').lsp_definitions()<CR>")
map("n", "<leader>vtd", ":lua require('telescope.builtin').lsp_type_definitions()<CR>")
map("n", "<leader>vi", ":lua require('telescope.builtin').lsp_implementations()<CR>")
map("n", "<leader>vsh", ":lua vim.lsp.buf.signature_help()<CR>")
map("n", "<leader>vrr", ":lua require('telescope.builtin').lsp_references()<CR>")
map("n", "<leader>vrn", ":lua vim.lsp.buf.rename()<CR>")
map("n", "<leader>vh", ":lua vim.lsp.buf.hover()<CR>")
map("v", "<leader>vh", ":lua require('metals').type_of_range()<CR>")
map("n", "<leader>vca", ":lua vim.lsp.buf.code_action()<CR>")
map("n", "<leader>vcl", ":lua vim.lsp.codelens.run()<CR>")
map("n", "<leader>vsd", ":lua require('telescope.builtin').diagnostics()<CR>")

map("n", "<leader>vse", ":lua vim.diagnostic.setqflist({ severity = 'E' })<CR>")
map("n", "<leader>nd", ":lua vim.diagnostic.goto_next()<CR>")
map("n", "<leader>pd", ":lua vim.diagnostic.goto_prev()<CR>")


map("n", "<leader>ld", ":lua vim.diagnostic.open_float(0, { scope = 'line' })<CR>")
map("v", "<leader>p", "\"_dP")
map("n", "<leader>y", "\"+y")
map("v", "<leader>y", "\"+y")
map("n", "<leader>Y", "gg\"+yG")

map("n", "<silent>", "<leader>ff <cmd>lua vim.lsp.buf.formatting()<CR>")
map("n", "<silent>", "<leader>fjf :%!js-beautify %<CR>")

map("n", "<leader>m", ":MaximizerToggle!<CR>")
map("n", "<Esc>", ":noh<CR><esc>")


map("v", "M", [[<Esc><cmd>lua require("metals").type_of_range()<CR>]])
-- map("n", "<leader>ws", [[<cmd>lua require("metals").hover_worksheet()<CR>]])
map("n", "<leader>st", [[<cmd>lua require("metals").toggle_setting("showImplicitArguments")<CR>]])

map("n", "<leader>hp", ":Gitsigns preview_hunk<CR>")
map("n", "<leader>gdt", ":Gitsigns diffthis<CR>")

map("n", "<leader>gsb", ":Gitsigns toggle_current_line_blame<CR>")

map('n', '<leader>j', "&diff ? '<leader>gn' : '<cmd>Gitsigns next_hunk<CR>'", {expr=true})
map('n', '<leader>k', "&diff ? '<leader>gp' : '<cmd>Gitsigns prev_hunk<CR>'", {expr=true})

-- dap
-- Example mappings for usage with nvim-dap. If you don't use that, you can
-- skip these
map("n", "<leader>dc", ":lua require('dap').continue()<CR>")
map("n", "<leader>dr", ":lua require('dap').repl.toggle()<CR>")
map("n", "<leader>dK", ":lua require('dap.ui.widgets').hover()<CR>")
map("n", "<leader>dt", ":lua require('dap').toggle_breakpoint()<CR>")
map("n", "<leader>dso", ":lua require('dap').step_over()<CR>")
map("n", "<leader>dsi", ":lua require('dap').step_into()<CR>")
map("n", "<leader>dl", ":lua require('dap').run_last()<CR>")

local wrap_mapping = function(mapping)
    return mapping .. ':IndentBlanklineRefresh<CR>'
  end

vim.keymap.set('n', '<leader><TAB>', wrap_mapping('za'), {silent = true})
vim.keymap.set('n', '<leader>aw', wrap_mapping('zM') .. wrap_mapping('zr'), {silent = true})
vim.keymap.set('n', 'zm', wrap_mapping('zm'), {silent = true})
vim.keymap.set('n', 'zM', wrap_mapping('zM'), {silent = true})
vim.keymap.set('n', 'zr', wrap_mapping('zr'), {silent = true})
vim.keymap.set('n', 'zR', wrap_mapping('zR'), {silent = true})

-- map("n", "<leader>tt", [[<cmd>lua require("metals.tvp").toggle_tree_view()<CR>]])
--complete map("n", "<leader>tr", [[<cmd>lua require("metals.tvp").reveal_in_tree()<CR>]])

