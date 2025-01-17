return {
    { "toppair/peek.nvim",            lazy = true }, -- markdown
    { 'chomosuke/typst-preview.nvim', lazy = true }, -- typst
    { 'hat0uma/csvview.nvim',         lazy = true }, -- csv
    {
        "omni-preview",
        dir = "~/documents/projects/omni-preview.nvim",
        config = function()
            require("omni-preview").setup()
            vim.keymap.set("n", "<leader>p", ":OmniPreviewToggle<CR>", { silent = true })
        end
    }
}
