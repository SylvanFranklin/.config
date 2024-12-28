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

vim.lsp.set_log_level("debug")
require('mason').setup({})
require('mason-lspconfig').setup({})
require("mason-lspconfig").setup_handlers {
    -- The first entry (without a key) will be the default handler
    -- and will be called for each installed server that doesn't have
    -- a dedicated handler.
    function(server_name) -- default handler (optional)
        require("lspconfig")[server_name].setup {}
    end,
    -- Next, you can provide a dedicated handler for specific servers.
    -- For example, a handler override for the `rust_analyzer`:
    ["lua_ls"] = function()
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
    end
}

-- require("lspconfig")["tinymist"].setup {
--     settings = {
--         tinymist = {
--             settings = {
--                 formatterMode = "typstyle",
--                 exportPdf = "onType",
--                 semanticTokens = "disable"
--             },
--         },
--     },
-- }


for _, method in ipairs({ 'textDocument/diagnostic', 'workspace/diagnostic' }) do
    local default_diagnostic_handler = vim.lsp.handlers[method]
    vim.lsp.handlers[method] = function(err, result, context, config)
        if err ~= nil and err.code == -32802 then
            return
        end
        return default_diagnostic_handler(err, result, context, config)
    end
end
