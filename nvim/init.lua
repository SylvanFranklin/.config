vim.cmd([[set mouse=]])
vim.cmd([[set noswapfile]])
vim.opt.winborder = "rounded"
vim.opt.tabstop = 2
vim.opt.wrap = false
vim.opt.cursorcolumn = false
vim.opt.ignorecase = true
vim.opt.shiftwidth = 2
vim.opt.smartindent = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.termguicolors = true
vim.opt.undofile = true
vim.opt.signcolumn = "yes"

local map = vim.keymap.set
vim.g.mapleader = " "
map('n', '<leader>o', ':update<CR> :source<CR>')
map('n', '<leader>w', ':write<CR>')
map('n', '<leader>r', ':update<CR> :make<CR>')
map('n', '<leader>q', ':quit<CR>')
map('n', '<leader>v', ':e $MYVIMRC<CR>')
map('n', '<leader>z', ':e ~/.config/zsh/.zshrc<CR>')
map('n', '<leader>s', ':e #<CR>')
map('n', '<leader>S', ':sf #<CR>')
map({ 'n', 'v' }, '<leader>y', '"+y')
map({ 'n', 'v' }, '<leader>d', '"+d')
map({ 'n', 'v' }, '<leader>c', '1z=')

vim.pack.add({
	{ src = "https://github.com/vague2k/vague.nvim" },
	{ src = "https://github.com/stevearc/oil.nvim" },
	{ src = "https://github.com/echasnovski/mini.pick" },
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "main" },
	{ src = "https://github.com/chomosuke/typst-preview.nvim" },
	{ src = 'https://github.com/neovim/nvim-lspconfig' },
	{ src = "https://github.com/mason-org/mason.nvim" },
	{ src = "https://github.com/L3MON4D3/LuaSnip" },
	{ src = "https://github.com/SylvanFranklin/pear" },
})

require "mason".setup()
require "mini.pick".setup({
	mappings = {
		choose_marked = "<C-G>"
	}
})
require "oil".setup()


map('n', '<leader>f', ":Pick files<CR>")
map('n', '<leader>b', function() require("pear").jump_pair() end)
map('n', '<leader>h', ":Pick help<CR>")
map('n', '<leader>e', ":Oil<CR>")
map('t', '', "")
map('t', '', "")
map('n', '<leader>lf', vim.lsp.buf.format)

vim.lsp.enable(
	{ "lua_ls", "svelte", "tinymist", "emmetls", "rust_analyzer", "clangd", "glsl_analyzer" })

-- colors
require "vague".setup({ transparent = true })
vim.cmd("colorscheme vague")
vim.cmd(":hi statusline guibg=NONE")

-- snippets
require("luasnip").setup({ enable_autosnippets = true })
require("luasnip.loaders.from_lua").load({ paths = "~/.config/nvim/snippets/" })
local ls = require("luasnip")
map("i", "<C-e>", function() ls.expand_or_jump(1) end, { silent = true })
-- map({ "i", "s" }, "<C-J>", function() ls.jump(1) end, { silent = true })
-- map({ "i", "s" }, "<C-K>", function() ls.jump(-1) end, { silent = true })
