return {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
        local harpoon = require "harpoon"
        harpoon:setup()
        vim.keymap.set("n", "<leader>a", function() harpoon:list():add() end)
        vim.keymap.set("n", "<C-h>", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)
        vim.keymap.set("n", "<leader>s", function() harpoon:list():select(1) end)
        vim.keymap.set("n", "<leader>t", function() harpoon:list():select(2) end)
        vim.keymap.set("n", "<leader>d", function() harpoon:list():select(3) end)
        vim.keymap.set("n", "<leader>v", function() harpoon:list():select(4) end)
    end
}
