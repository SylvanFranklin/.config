return {
    "folke/trouble.nvim",
    -- opts = {
    --     -- win = {
    --     --     type = "floating"
    --     -- }
    --     warn_no_results = "false",
    -- },
    cmd = "Trouble",
    keys = {
        {
            "<leader>lq",
            "<cmd>Trouble diagnostics toggle<cr>",
            desc = "Diagnostics (Trouble)",
        },
        {
            "<leader>ls",
            "<cmd>Trouble symbols toggle focus=false<cr>",
            desc = "Symbols (Trouble)",
        },
        {
            "<leader>la",
            "<cmd>Trouble qflist toggle<cr>",
            desc = "Quickfix List (Trouble)",
        },
    },
    config = function()
        require("trouble").setup {
            focus = true,
            warn_no_results = false,
        }
    end
}
