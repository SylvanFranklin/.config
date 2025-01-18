return {
    { "toppair/peek.nvim",            lazy = true, build = "deno task --quiet build:fast" }, -- markdown
    { 'chomosuke/typst-preview.nvim', lazy = true },                                         -- typst
    { 'hat0uma/csvview.nvim',         lazy = true },                                         -- csv
    {
        "omni-preview",
        dir = "~/documents/projects/omni-preview.nvim",
        config = function()
            require("omni-preview").setup({})
            require("typst-preview").setup({
                dependencies_bin = {
                    ['tinymist'] = nil,
                    ['websocat'] = nil
                },
            })
            vim.keymap.set("n", "<leader>p", ":OmniPreviewToggle<CR>", { silent = true })
        end
    }
}
