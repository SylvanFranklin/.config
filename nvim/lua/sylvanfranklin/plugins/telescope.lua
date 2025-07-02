return {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.5",
    dependencies = { 'nvim-telescope/telescope-ui-select.nvim', "nvim-lua/plenary.nvim", { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' } },
    config = function()
        require('telescope').setup({
            extensions = {
                fzf = {
                    fuzzy = true,
                    override_generic_sorter = true,
                    override_file_sorter = true,
                    case_mode = "smart_case",
                }
            }
        })
        local builtin = require('telescope.builtin')
        local previewers = require('telescope.previewers')
        vim.keymap.set('n', '<leader>F', builtin.find_files, { silent = true })
        vim.keymap.set("n", "<leader>G", builtin.live_grep, { silent = true })
        vim.keymap.set("n", "<leader>r", ":Telescope oldfiles<CR>", { silent = true })
        vim.keymap.set('n', '<leader>h', builtin.help_tags, { desc = 'Telescope help tags' })
        -- vim.keymap.set('n', '<leader>c', builtin.commands, { desc = 'Telescope help tags' })
        vim.keymap.set('n', '<leader>lt', builtin.treesitter, { desc = 'List functions' })
        vim.keymap.set('n', '<leader>la', vim.lsp.buf.code_action, { desc = 'List functions' })
        vim.keymap.set('n', '<leader>lq', '<cmd>Telescope diagnostics<CR>', { desc = 'List functions' })
        vim.keymap.set('n', '<leader>lt', builtin.treesitter, { desc = 'List functions' })
        require('telescope').load_extension('fzf')
        require("telescope").load_extension("ui-select")
    end

}
