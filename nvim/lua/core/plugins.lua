local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable",
        lazypath,
    })
end

vim.opt.rtp:prepend(lazypath)

-- Plugins
require("lazy").setup({
    -- general
    {
        "ThePrimeagen/harpoon",
        branch = "harpoon2",
        dependencies = { 'nvim-lua/plenary.nvim' }
    },
    {
        'hat0uma/csvview.nvim',
        config = function()
            require('csvview').setup(
                {
                    view = {
                        -- min_column_width = 5,
                        spacing = 2,
                        display_mode = "border",
                    },
                }
            )
        end
    },
    -- {
    --     "otavioschwanck/arrow.nvim",
    --     lazy=false,
    --     opts = {
    --         leader_key = ';', -- Recommended to be a single key
    --         buffer_leader_key = 'm', -- Per Buffer Mappings
    --     }
    -- },
    {
        'numToStr/Comment.nvim',
        lazy = false,
    },
    {
        'nvim-telescope/telescope.nvim',
        tag = '0.1.5',
        dependencies = { 'nvim-lua/plenary.nvim' }
    },
    {
        'stevearc/oil.nvim',
        opts = {
            view_options = {
                show_hidden = true,
            }
        },

        dependencies = { "nvim-tree/nvim-web-devicons" },
    },
    { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
    {
        "L3MON4D3/LuaSnip",
        version = "v2.*",
        build = "make install_jsregexp"
    },

    -- lsp config
    { "nvim-treesitter/nvim-treesitter",          build = ":TSUpdate" },
    { 'VonHeikemen/lsp-zero.nvim',                branch = 'v3.x' },
    { 'neovim/nvim-lspconfig' },
    { 'hrsh7th/cmp-nvim-lsp' },
    { 'hrsh7th/nvim-cmp' },
    { 'williamboman/mason.nvim' },
    { 'williamboman/mason-lspconfig.nvim' },
    { 'aznhe21/actions-preview.nvim' },
    {
        "folke/trouble.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        opts = {},
    },

    -- Cosmetic plugins
    { "folke/zen-mode.nvim" },
    { "vague2k/vague.nvim" },
    {
        "toppair/peek.nvim",
        event = { "VeryLazy" },
        build = "deno task --quiet build:fast",
        config = function()
            require("peek").setup({ app = "browser" })
            vim.api.nvim_create_user_command("PeekOpen", require("peek").open, {})
            vim.api.nvim_create_user_command("PeekClose", require("peek").close, {})
        end,
    },
    {
        'chomosuke/typst-preview.nvim',
        lazy = false, -- or ft = 'typst'
        version = '1.*',
        opts = {}, -- lazy.nvim will implicitly calls `setup {}`
    }
})
