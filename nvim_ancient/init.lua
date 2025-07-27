vim.opt.number = true
vim.opt.winborder = "rounded"
vim.opt.swapfile = false
vim.opt.wrap = false
vim.opt.tabstop = 2
vim.opt.relativenumber = true
vim.opt.signcolumn = "yes"
vim.opt.path = "**"
vim.opt.mouse = ""
vim.g.mapleader = " "

vim.keymap.set("n", "<leader>o", ":write<CR> :source<CR>")
vim.keymap.set("n", "<leader>w", ":write<CR>")
vim.keymap.set("n", "<leader>q", ":quit<CR>")

vim.pack.add({
	{ src = "https://github.com/vague2k/vague.nvim" },
	{ src = "https://github.com/stevearc/oil.nvim" },
	{ src = "https://github.com/echasnovski/mini.pick" },
	{ src = "https://github.com/neovim/nvim-lspconfig" },
	{ src = "https://github.com/chomosuke/typst-preview.nvim" },
})

vim.keymap.set("n", "<leader>f", ":Pick files<CR>")
vim.keymap.set("n", "<leader>p", ":TypstPreview<CR>")
vim.keymap.set("n", "<leader>h", ":Pick help<CR>")
vim.keymap.set("n", "<leader>e", ":Oil<CR> ")
vim.keymap.set("n", "<leader>lf", vim.lsp.buf.format)


require "mini.pick".setup()
require "oil".setup()
require "vague".setup({ transparent = true })

vim.api.nvim_create_autocmd('LspAttach', {
	callback = function(ev)
		local client = vim.lsp.get_client_by_id(ev.data.client_id)
		if client:supports_method('textDocument/completion') then
			vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
		end
	end,
})
vim.cmd("set completeopt+=noselect")


vim.lsp.enable({ "lua_ls", "rust_analyzer", "svelte-language-server", "tinymist" })
-- theme
vim.cmd([[colorscheme vague]])
vim.cmd([[hi statusline guibg=NONE]])
