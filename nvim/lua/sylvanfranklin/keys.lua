-- general
vim.g.mapleader = " "
vim.keymap.set("n", "<leader>h", ":set hlsearch!<CR>")
vim.keymap.set("n", "<leader>q", ":q<CR>")
vim.keymap.set("n", "<leader>w", ":w<CR>")
vim.keymap.set({ "n", "v" }, "<leader>y", '"+y')
vim.keymap.set({ "n", "v" }, "<leader>d", '"+d')

-- plugin
vim.keymap.set({ "n", "x" }, "<leader>e", ":Oil<CR>", { silent = true })
vim.keymap.set({ "n", "x" }, "<C-L>", ":Lazy<CR>", { silent = true })
vim.keymap.set({ "n", "x" }, "<C-M>", ":Mason<CR>", { silent = true })

-- totally remove mouse, and arrow keys
-- vim.opt.mouse = ""
-- vim.keymap.set({ "n", "x", "v" }, "<up>", "<nop>")
-- vim.keymap.set({ "n", "x", "v" }, "<down>", "<nop>")
-- vim.keymap.set({ "n", "x", "v" }, "<left>", "<nop>")
-- vim.keymap.set({ "n", "x", "v" }, "<right>", "<nop>")
