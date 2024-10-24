local lsp_zero = require('lsp-zero')


vim.api.nvim_create_autocmd("BufEnter", {
    pattern = { "*.typ", "*.md" },
    callback = function()
        vim.cmd(":map j gj")
        vim.cmd(":map k gk")
        vim.cmd(":Copilot disable")
    end
})

lsp_zero.on_attach(function(client, bufnr)
    -- see :help lsp-zero-keybindings
    -- to learn the available actions
    lsp_zero.default_keymaps({ buffer = bufnr })
end)

require('mason').setup({})
require('mason-lspconfig').setup({
    handlers = {
        lsp_zero.default_setup,
    },
})


local cmp = require('cmp')
local cmp_action = require('lsp-zero').cmp_action()
cmp.setup({
    mapping = cmp.mapping.preset.insert({
        ['<C-j>'] = cmp_action.luasnip_jump_forward(),
        ['<C-l>'] = cmp_action.luasnip_jump_backward(),
        ['<Cr>'] = cmp.mapping.confirm({ select = true }),
        ['<C-u>'] = cmp.mapping.scroll_docs(-4),
        ['<C-d>'] = cmp.mapping.scroll_docs(4),

    })
})
