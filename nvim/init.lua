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

vim.pack.add({
	{ src = "https://github.com/vague2k/vague.nvim" },
	{ src = "https://github.com/chentoast/marks.nvim" },
	{ src = "https://github.com/stevearc/oil.nvim" },
	{ src = "https://github.com/echasnovski/mini.nvim" },
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "main" },
	{ src = "https://github.com/chomosuke/typst-preview.nvim" },
	{ src = 'https://github.com/neovim/nvim-lspconfig' },
	{ src = "https://github.com/mason-org/mason.nvim" },
	{ src = "https://github.com/L3MON4D3/LuaSnip" },
	{ src = "https://github.com/SylvanFranklin/pear" },
})

require 'marks'.setup {
	builtin_marks = { "<", ">", "^" },
	force_write_shada = false,
	refresh_interval = 250,
	sign_priority = { lower = 10, upper = 15, builtin = 8, bookmark = 20 },
	excluded_filetypes = {},
	excluded_buftypes = {},
	mappings = {}

}
require "mason".setup()
require "mini.pick".setup()
require "mini.bufremove".setup()
require "mini.bufremove".setup()

require("oil").setup({
	lsp_file_methods = {
		enabled = true,
		timeout_ms = 1000,
		autosave_changes = true,
	},
	float = {
		max_width = 0.7,
		max_height = 0.6,
		border = "rounded",
	},
})

vim.api.nvim_create_autocmd('LspAttach', {
	group = vim.api.nvim_create_augroup('my.lsp', {}),
	callback = function(args)
		local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
		if client:supports_method('textDocument/completion') then
			-- Optional: trigger autocompletion on EVERY keypress. May be slow!
			local chars = {}; for i = 32, 126 do table.insert(chars, string.char(i)) end
			client.server_capabilities.completionProvider.triggerCharacters = chars
			vim.lsp.completion.enable(true, client.id, args.buf, { autotrigger = true })
		end
	end,
})

-- LSP
vim.lsp.enable(
	{
		"lua_ls",
		"css-lsp",
		"svelte",
		"tinymist",
		"emmetls",
		"rust_analyzer",
		"clangd",
		"ruff",
		"glsl_analyzer",
		"haskell-language-server",
		"hlint",
		"intelephense"

	}
)
vim.cmd [[set completeopt+=menuone,noselect,popup]]

-- colors
require "vague".setup({ transparent = true })
vim.cmd("colorscheme vague")
vim.cmd(":hi statusline guibg=NONE")

-- snippets
require("luasnip").setup({ enable_autosnippets = true })
require("luasnip.loaders.from_lua").load({ paths = "~/.config/nvim/snippets/" })
local ls = require("luasnip")

-- mappings
local map = vim.keymap.set
vim.g.mapleader = " "
map('n', '<leader>w', '<Cmd>write<CR>')
map('n', '<leader>bd', require("mini.bufremove").delete)
map('n', '<leader>q', '<Cmd>:quit<CR>')
map('n', '<leader>Q', '<Cmd>:wqa<CR>')
map('n', '<C-f>', '<Cmd>Open .<CR>')
map({ 'n', 'v', 'x' }, ';', ':')
map({ 'n', 'v', 'x' }, ':', ';')

-- open RC files.
map('n', '<leader>v', '<Cmd>e $MYVIMRC<CR>')
map('n', '<leader>z', '<Cmd>e ~/.config/zsh/.zshrc<CR>')

-- quickly switch files with alternate / switch it
map('n', '<leader>s', '<Cmd>e #<CR>')
map('n', '<leader>S', '<Cmd>bot sf #<CR>')
map({ 'n', 'v', 'x' }, '<leader>m', ':move ')

-- I use norm so much this makes sense
map({ 'n', 'v' }, '<leader>n', ':norm ')

-- system clipboard
map({ 'n', 'v' }, '<leader>y', '"+y')
map({ 'n', 'v' }, '<leader>d', '"+d')
map({ 'n', 'v' }, '<leader>c', ':')

-- soft reload config file
map({ 'n', 'v' }, '<leader>o', ':update<CR> :source<CR>')

map('t', '', "")
map('t', '', "")

map('n', '<leader>lf', vim.lsp.buf.format)

map("i", "<C-e>", function() ls.expand_or_jump(1) end, { silent = true })
map({ "i", "s" }, "<C-J>", function() ls.jump(1) end, { silent = true })
map({ "i", "s" }, "<C-K>", function() ls.jump(-1) end, { silent = true })

map('n', '<leader>g', "<Cmd>Pick grep_live<CR>")
map('n', '<leader>f', "<Cmd>Pick files<CR>")
map('n', '<leader>r', "<Cmd>Pick buffers<CR>")

map('n', '<leader>b', function() require("pear").jump_pair() end)
map('n', '<leader>h', "<Cmd>Pick help<CR>")
map('n', '<leader>e', "<Cmd>Oil<CR>")
map('n', '<leader>E', require("oil").open_float)
map('i', '<c-e>', function() vim.lsp.completion.get() end)

map("n", "<M-n>", "<cmd>resize +2<CR>")          -- Increase height
map("n", "<M-e>", "<cmd>resize -2<CR>")          -- Decrease height
map("n", "<M-i>", "<cmd>vertical resize +5<CR>") -- Increase width
map("n", "<M-m>", "<cmd>vertical resize -5<CR>") -- Decrease width
map("i", "<C-s>", "<c-g>u<Esc>[s1z=`]a<c-g>u")


map("n", "<C-q>", ":copen<CR>", { silent = true })

for i = 1, 9 do
	map('n', '<leader>' .. i, ':cc ' .. i .. '<CR>', { noremap = true, silent = true })
end

map("n", "<leader>a",
	function() vim.fn.setqflist({ { filename = vim.fn.expand("%"), lnum = 1, col = 1, text = vim.fn.expand("%"), } }, "a") end,
	{ desc = "Add current file to QuickFix" })


vim.api.nvim_create_autocmd("BufWinEnter", {
	pattern = "*",
	group = vim.api.nvim_create_augroup("qf", { clear = true }),
	callback = function()
		if vim.bo.buftype == "quickfix" then
			map("n", "<C-q>", ":ccl<cr>", { buffer = true, silent = true })
			map("n", "dd", function()
				local idx = vim.fn.line('.')
				local qflist = vim.fn.getqflist()
				table.remove(qflist, idx)
				vim.fn.setqflist(qflist, 'r')
			end, { buffer = true })
		end
	end,
})
