_ = vim.cmd [[packadd packer.nvim]]

return require("packer").startup {
  function(use)

    use "chriskempson/base16-vim"

    use "tpope/vim-commentary"
    use "tpope/vim-surround"
    use "tpope/vim-fugitive"

    use { "nvim-lua/telescope.nvim",
      requires = {
        { "nvim-lua/popup.nvim" },
        { "nvim-lua/plenary.nvim" },
        { "nvim-telescope/telescope-fzy-native.nvim" },
        { "debugloop/telescope-undo.nvim"},
      },
    }

    use { "junegunn/fzf", run = function() vim.fn["fzf#install()"](0) end }
    use "junegunn/fzf.vim"
    use "lewis6991/gitsigns.nvim"

    use {"ckipp01/stylua-nvim", run = "cargo install stylua"}

    -- use "lukas-reineke/indent-blankline.nvim"
    use "neovim/nvim-lspconfig"
    use "~/Projects/nvim-metals"
    -- use { "catppuccin/nvim", as = "catppuccin" }
    -- use "scalameta/nvim-metals"
    use "mfussenegger/nvim-dap"

    use "hrsh7th/nvim-cmp"
    use "hrsh7th/cmp-nvim-lsp"
    use "hrsh7th/cmp-buffer"
    use "hrsh7th/cmp-path"
    use "hrsh7th/cmp-cmdline"
    use "hrsh7th/cmp-vsnip"
    -- use "hrsh7th/cmp-nvim-lsp-signature-help"

    use "~/Projects/cmp-nvim-lsp-signature-help"
    use "onsails/lspkind-nvim"
    use "hrsh7th/vim-vsnip"
    use "windwp/nvim-autopairs"
    -- use "ray-x/lsp_signature.nvim"
    use "wbthomason/packer.nvim"
    use "petertriho/nvim-scrollbar"
    -- use "https://git.sr.ht/~whynothugo/lsp_lines.nvim"

    use "nvim-treesitter/nvim-treesitter"
    use "nvim-treesitter/playground"
    use "VidocqH/lsp-lens.nvim"
    use "szw/vim-maximizer"
    use "rebelot/kanagawa.nvim"

    use 'nvim-tree/nvim-web-devicons'
    use 'stevearc/oil.nvim'

    use "folke/neodev.nvim"
    use {
        'folke/todo-comments.nvim',
        requires = 'nvim-lua/plenary.nvim',
    }
    use "folke/zen-mode.nvim"

    use {
        'ruifm/gitlinker.nvim',
        requires = 'nvim-lua/plenary.nvim',
    }
    -- use "github/copilot.vim"
    use { "zbirenbaum/copilot.lua" }
    use {
      "CopilotC-Nvim/CopilotChat.nvim",
      requires = {
        { 'zbirenbaum/copilot.lua'},
        { "nvim-lua/plenary.nvim" },
      }
    }
    -- use "lvimuser/lsp-inlayhints.nvim"
    use "sindrets/diffview.nvim"
    -- use { 'sourcegraph/sg.nvim', run = 'nvim -l build/init.lua' }


-- Plug "tjdevries/lsp_extensions.nvim"


  end
}
