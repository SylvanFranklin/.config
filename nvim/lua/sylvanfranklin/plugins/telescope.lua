return {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.5",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
        require('telescope').setup()
        local builtin = require('telescope.builtin')
        vim.keymap.set('n', '<leader>f', builtin.find_files, { silent = true })
        vim.keymap.set('n', '<leader>if', builtin.git_files, { silent = true })
        vim.keymap.set("n", "<leader>g", ":Telescope live_grep<CR>", { silent = true })
        vim.keymap.set("n", "<leader>r", ":Telescope oldfiles<CR>", { silent = true })
    end
}
