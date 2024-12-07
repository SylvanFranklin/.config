local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

-- Plugins
require("lazy").setup({
    -- general
    { "vague2k/vague.nvim" },
    { "CRAG666/code_runner.nvim", config = true },
    { "github/copilot.vim" },
    {
        "ThePrimeagen/harpoon",
        branch = "harpoon2",
        dependencies = { 'nvim-lua/plenary.nvim' }
    },
    -- {
    --     "otavioschwanck/arrow.nvim",
    --     dependencies = {
    --         { "nvim-tree/nvim-web-devicons" },
    --     },
    --     opts = {
    --         show_icons = true,
    --         leader_key = ';', -- Recommended to be a single key
    --         buffer_leader_key = 'm', -- Per Buffer Mappings
    --     }
    -- },
    {
        'windwp/nvim-autopairs',
        event = "InsertEnter",
        config = true
        -- use opts = {} for passing setup options
        -- this is equivalent to setup({}) function
    },


    {
        'numToStr/Comment.nvim',
        lazy = false,
    },
    {
        'nvim-telescope/telescope.nvim',
        tag = '0.1.5',
        dependencies = { 'nvim-lua/plenary.nvim' }
    },
    { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },

    -- lsp config
    { "nvim-treesitter/nvim-treesitter",          build = ":TSUpdate" },
    {
        'saecki/crates.nvim',
        tag = 'stable',
        config = function()
            require('crates').setup()
        end,
    },

    { 'VonHeikemen/lsp-zero.nvim', branch = 'v3.x' },
    {
        'neovim/nvim-lspconfig',
    },
    { 'hrsh7th/cmp-nvim-lsp' },
    { 'hrsh7th/nvim-cmp' },
    {
        "L3MON4D3/LuaSnip",
        -- follow latest release.
        version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
        -- install jsregexp (optional!).
        build = "make install_jsregexp"
    },
    {
        'williamboman/mason.nvim',
        opts = {
            ensure_installed = {
                "tinymist",
            },
        }
    },
    { 'williamboman/mason-lspconfig.nvim' },
    { 'aznhe21/actions-preview.nvim' },
    {
        "folke/trouble.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        opts = {},
    },
    {
        'stevearc/oil.nvim',
        opts = {},
        dependencies = { "nvim-tree/nvim-web-devicons" },
    },


    {
        'chomosuke/typst-preview.nvim',
        lazy = false, -- or ft = 'typst'
        version = '1.*',
        build = function() require 'typst-preview'.update() end,
    },

    -- Cosmetic plugins
    {
        "folke/zen-mode.nvim",
        opts = {}
    },

    {
        "sainnhe/everforest",
    },
    {
        'MeanderingProgrammer/render-markdown.nvim',
        dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }, -- if you prefer nvim-web-devicons
        ---@module 'render-markdown'
        ---@type render.md.UserConfig
        opts = {},
    }

})
