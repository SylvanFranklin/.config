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
	{ src = "https://github.com/stevearc/oil.nvim" },
	{ src = "https://github.com/echasnovski/mini.nvim" },
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "main" },
	{ src = "nvim-treesitter/nvim-treesitter-textobjects" },
	{ src = "https://github.com/chomosuke/typst-preview.nvim" },
	{ src = 'https://github.com/neovim/nvim-lspconfig' },
	{ src = "https://github.com/mason-org/mason.nvim" },
	{ src = "https://github.com/L3MON4D3/LuaSnip" },
	{ src = "https://github.com/SylvanFranklin/pear" },
})

require "mason".setup()
require "mini.pick".setup()
require "mini.bufremove".setup()
require "oil".setup()

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

-- lsp
vim.lsp.enable(
	{
		"lua_ls",
		"svelte",
		"tinymist",
		"emmetls",
		"rust_analyzer",
		"clangd",
		"ruff",
		"glsl_analyzer",
		"haskell-language-server",
		"hlint",

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
map('n', '<leader>q', require("mini.bufremove").delete)
map('n', '<C-f>', '<Cmd>Open .<CR>')
map('n', '<leader>v', '<Cmd>e $MYVIMRC<CR>')
map('n', '<leader>z', '<Cmd>e ~/.config/zsh/.zshrc<CR>')
map('n', '<leader>s', '<Cmd>e #<CR>')
map('n', '<leader>S', '<Cmd>bot sf #<CR>')
map({ 'n', 'v' }, '<leader>n', ':norm ')
map({ 'n', 'v' }, '<leader>y', '"+y')
map({ 'n', 'v' }, '<leader>d', '"+d')
map({ 'n', 'v' }, '<leader>c', '1z=')
map({ 'n', 'v' }, '<leader>o', ':update<CR> :source<CR>')
map('t', '', "")
map('t', '', "")
map('n', '<leader>lf', vim.lsp.buf.format)
map("i", "<C-e>", function() ls.expand_or_jump(1) end, { silent = true })
map({ "i", "s" }, "<C-J>", function() ls.jump(1) end, { silent = true })
map({ "i", "s" }, "<C-K>", function() ls.jump(-1) end, { silent = true })
map('n', '<leader>f', "<Cmd>Pick files<CR>")
map('n', '<leader>r', "<Cmd>Pick buffers<CR>")
map('n', '<leader>b', function() require("pear").jump_pair() end)
map('n', '<leader>h', "<Cmd>Pick help<CR>")
map('n', '<leader>e', "<Cmd>Oil<CR>")
map('i', '<c-e>', function() vim.lsp.completion.get() end)
