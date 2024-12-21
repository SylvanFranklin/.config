local lsp_zero = require('lsp-zero')

vim.api.nvim_create_autocmd("BufEnter", {
    pattern = { "*.csv" },
    callback = function()
        vim.cmd(":CsvViewEnable")
    end
})

vim.api.nvim_create_autocmd("BufEnter", {
    pattern = { "*.typ", "*.md" },
    callback = function()
        vim.cmd(":map j gj")
        vim.cmd(":map k gk")
        -- vim.cmd(":set wrap")
        -- vim.cmd(":Copilot disable")
    end
})

lsp_zero.on_attach(function(client, bufnr)
    lsp_zero.default_keymaps({ buffer = bufnr })
end)

require('mason').setup({})
require('mason-lspconfig').setup({
    ensure_installed = { "lua_ls", "rust_analyzer", "tinymist" },
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

require("lspconfig")["tinymist"].setup {
    settings = {
        tinymist = {
            settings = {
                formatterMode = "typstyle",
                exportPdf = "onType",
                semanticTokens = "disable"
            },
        },
    },
}

require("lspconfig")["lua_ls"].setup {
    settings = {
        Lua = {
            runtime = {
                -- Tell the language server which version of Lua you're using
                -- (most likely LuaJIT in the case of Neovim)
                version = 'LuaJIT',
            },
            diagnostics = {
                -- Get the language server to recognize the `vim` global
                globals = {
                    'vim',
                    'require'
                },
            },
            workspace = {
                -- Make the server aware of Neovim runtime files
                library = vim.api.nvim_get_runtime_file("", true),
            },
            -- Do not send telemetry data containing a randomized but unique identifier
            telemetry = {
                enable = false,
            },
        },
    },
}

for _, method in ipairs({ 'textDocument/diagnostic', 'workspace/diagnostic' }) do
    local default_diagnostic_handler = vim.lsp.handlers[method]
    vim.lsp.handlers[method] = function(err, result, context, config)
        if err ~= nil and err.code == -32802 then
            return
        end
        return default_diagnostic_handler(err, result, context, config)
    end
end
