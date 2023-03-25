require("telescope").setup({
  defaults = {
    file_ignore_patterns = { "target", "node_modules", "parser.c", "out/", "%.min.js", "^community-build/*"},
    prompt_prefix = "❯ ",
    file_previewer = require("telescope.previewers").vim_buffer_cat.new,
    grep_previewer = require("telescope.previewers").vim_buffer_vimgrep.new,
  },
})

require("telescope").load_extension("fzy_native")
require("telescope").load_extension("undo")
