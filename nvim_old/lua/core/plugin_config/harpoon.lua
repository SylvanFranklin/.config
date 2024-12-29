local harpoon = require("harpoon")

-- REQUIRED
harpoon:setup()

-- harpoon
vim.keymap.set("n", "<leader>a", function() harpoon:list():add() end)
vim.keymap.set("n", "<C-h>", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)
vim.keymap.set("n", "<leader>s", function() harpoon:list():select(1) end)
vim.keymap.set("n", "<leader>t", function() harpoon:list():select(2) end)
vim.keymap.set("n", "<leader>d", function() harpoon:list():select(3) end)
vim.keymap.set("n", "<leader>v", function() harpoon:list():select(4) end)

-- Toggle previous & next buffers stored within Harpoon list
-- vim.keymap.set("n", "<C-S-P>", function() harpoon:list():prev() end)
-- vim.keymap.set("n", "<C-S-N>", function() harpoon:list():next() end)