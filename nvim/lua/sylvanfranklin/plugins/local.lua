return {
    "sylvanfranklin/omni-preview.nvim",
    dependencies = {
        { "toppair/peek.nvim",            lazy = true, build = "deno task --quiet build:fast" }, -- markdown
        { 'chomosuke/typst-preview.nvim', lazy = true },                                         -- typst
        { 'hat0uma/csvview.nvim',         lazy = true },                                         -- csv
    },
    config = function()
        require("omni-preview").setup()
        require("typst-preview").setup({
            dependencies_bin = {
                ['tinymist'] = "/Users/sylvanfranklin/.cargo/bin/tinymist",
                ['websocat'] = nil
            },
        })

        require("peek").setup({ app = "browser" })
        require("csvview").setup({
            view = {
                display_mode = "border"
            }
        })
        vim.keymap.set("n", "<leader>p", ":OmniPreview start<CR>", { silent = true })
    end
}
