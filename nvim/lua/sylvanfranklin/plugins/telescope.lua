return {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.5",
    dependencies = { "nvim-lua/plenary.nvim", { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' } },
    config = function()
        require('telescope').setup({
            extensions = {
                fzf = {
                    fuzzy = true,     -- false will only do exact matching
                    override_generic_sorter = true, -- override the generic sorter
                    override_file_sorter = true, -- override the file sorter
                    case_mode = "smart_case", -- or "ignore_case" or "respect_case"
                    -- the default case_mode is "smart_case"
                }
            }
        })
        local builtin = require('telescope.builtin')
        vim.keymap.set('n', '<leader>f', builtin.find_files, { silent = true })
        vim.keymap.set('n', '<leader>if', builtin.git_files, { silent = true })
        vim.keymap.set("n", "<leader>g", ":Telescope live_grep<CR>", { silent = true })
        vim.keymap.set("n", "<leader>r", ":Telescope oldfiles<CR>", { silent = true })
        require('telescope').load_extension('fzf')
    end

}
