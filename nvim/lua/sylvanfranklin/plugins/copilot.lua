return {
    "zbirenbaum/copilot.lua",
    config = function()
        require("copilot").setup(
            {
                suggestion = {
                    enabled = true,
                    auto_trigger = true,
                    hide_during_completion = false,
                    debounce = 75,
                    keymap = {
                        accept = "<Tab>",
                        accept_word = false,
                        accept_line = false,
                        next = "<M-]>",
                        prev = "<M-[>",
                        dismiss = "<C-]>",
                    },
                }
            }
        )

        vim.keymap.set("n", "<leader>ce", "<CMD>Copilot<CR>", { silent = true })
        vim.keymap.set("n", "<leader>cd", ":Copilot detach<CR>")
    end,
}
