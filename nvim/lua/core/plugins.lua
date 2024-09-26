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

    { 'VonHeikemen/lsp-zero.nvim',        branch = 'v3.x' },
    {
        'neovim/nvim-lspconfig',
    },
    { 'hrsh7th/cmp-nvim-lsp' },
    { 'hrsh7th/nvim-cmp' },
    { 'L3MON4D3/LuaSnip' },
    { 'williamboman/mason.nvim' },
    { 'williamboman/mason-lspconfig.nvim' },
    { 'aznhe21/actions-preview.nvim' },

    {
        "folke/trouble.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        opts = {
            -- your configuration comes here
            -- or leave it empty to use the default settings
            -- refer to the configuration section below
        },
    },
    -- { "CRAG666/code_runner.nvim",         config = true },

    -- file manager plugin
    {
        'stevearc/oil.nvim',
        opts = {},
        dependencies = { "nvim-tree/nvim-web-devicons" },
    },

    -- typst and latex plugins
    -- { "lervag/vimtex" },
    -- {
    { 'mhartington/formatter.nvim' },
    {
        'kaarmu/typst.vim',
        ft = 'typst',
        lazy = false,
    },

    {
        'chomosuke/typst-preview.nvim',
        lazy = false, -- or ft = 'typst'
        version = '0.1.*',
        build = function() require 'typst-preview'.update() end,
    },

    -- Lua
    {
        "folke/zen-mode.nvim",
        opts = {}
    },
})
