local CONFIG_VARIABLES = {}

local pickers   = require('telescope.pickers')
local finders = require('telescope.finders')
local conf = require('telescope.config').values
local actions = require('telescope.actions')
local actions_state = require('telescope.actions.state')
local lsp = require('lsp')

CONFIG_VARIABLES.config = {
  metals_server_version = 'latest.snapshot'
}

CONFIG_VARIABLES.set_metals_version = function()
  local opts = require("telescope.themes").get_dropdown{}
  local version = vim.fn.input("Enter metals version: ")
  lsp.update_metals_setting("serverVersion", version)
  -- pickers.new(opts, {
  --   prompt_title = 'Set project Metals version',
  --   finder = finders.new_table {
  --     results = {'1.0.2-SNAPSHOT', 'latest.snapshot'},
  --   },
  --   sorter = conf.generic_sorter(opts),
  --   attach_mappings = function(prompt_bufnr)
  --     actions.select_default:replace(function()
  --       actions.close(prompt_bufnr)
  --       local selection = actions_state.get_selected_entry(prompt_bufnr)
  --       lsp.update_metals_setting("serverVersion", selection[1])
  --     end)
  --     return true
  --   end,
  -- }):find()
end

return CONFIG_VARIABLES
