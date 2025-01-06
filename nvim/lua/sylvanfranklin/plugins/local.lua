return {
    {
        "chain-gun.nvim",
        dir = "~/Documents/projects/chain-gun.nvim/",
        config = function()
            require("chain-gun").setup({
                keymap = "<leader>c"
            })
        end
    },
}
