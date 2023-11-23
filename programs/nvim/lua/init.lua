pcall(require, "impatient")

if require("first_load")() then
	return
end

local g = vim.g

vim.g.mapleader = " "

require("plugins")
require("colorscheme")
require("options")
require("disable_builtin")
require("lsp")
require("config_variables")
require("mappings")
require("completions")
require("statusline")
require("augroups")
require("plugin_configuration")
require("telescope_settings")
require("treesitter")
require("visuals")


if vim.fn.executable("rg") then
    g.rg_derive_root = "true"
end
