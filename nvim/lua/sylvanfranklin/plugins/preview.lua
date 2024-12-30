return {
    {
        "toppair/peek.nvim",
        event = { "VeryLazy" },
        build = "deno task --quiet build:fast",
        config = function()
            require("peek").setup({ app = "browser" })
            vim.api.nvim_create_user_command("PeekOpen", require("peek").open, {})
            vim.api.nvim_create_user_command("PeekClose", require("peek").close, {})
        end
    },
    -- {
    --         'chomosuke/typst-preview.nvim',
    --         tag = 'v1.*',
    --         config = function()
    --             require 'typst-preview'.setup {}
    --         end,
    -- }
}
