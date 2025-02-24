return {
    "neovim/nvim-lspconfig",
    dependencies = {
        "williamboman/mason.nvim",
        "nvimdev/lspsaga.nvim",
        "williamboman/mason-lspconfig.nvim",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-cmdline",
        "jcha0713/cmp-tw2css",
        "hrsh7th/nvim-cmp",
    },

    config = function()
        vim.diagnostic.config({
            float = { border = "rounded" }
        })

        local cmp = require('cmp')
        local cmp_lsp = require("cmp_nvim_lsp")
        local capabilities = vim.tbl_deep_extend(
            "force",
            {},
            vim.lsp.protocol.make_client_capabilities(),
            cmp_lsp.default_capabilities())

        require("mason").setup()

        require("mason-lspconfig").setup({
            automatic_installation = false,
            ensure_installed = {
                'bashls',
                "lua_ls",
                "rust_analyzer",
                "tinymist",
            },
            handlers = {
                function(server_name)
                    require("lspconfig")[server_name].setup {
                        capabilities = capabilities
                    }
                end,
                ["svelte"] = function()
                    require("lspconfig")["svelte"].setup({
                        capabilities = capabilities,
                        on_attach = function(client, bufnr)
                            vim.api.nvim_create_autocmd("BufWritePost", {
                                pattern = { "*.js", "*.ts" },
                                callback = function(ctx)
                                    -- this bad boy updates imports between svelte and ts/js files
                                    client.notify("$/onDidChangeTsOrJsFile", { uri = ctx.match })
                                end,
                            })
                        end
                    })
                end,

                -- other config stuff, tested to be correct
                ["tinymist"] = function()
                    require("lspconfig")["tinymist"].setup {
                        capabilities = capabilities,
                        settings = {
                            formatterMode = "typstyle",
                            exportPdf = "never"
                        },

                    }

                    vim.api.nvim_create_user_command("Tinymist", function(opts)
                        local sub = opts.args
                        local command = "tinymist." .. sub
                        local client = {}

                        for _, v in pairs(vim.lsp.buf_get_clients(0)) do
                            if v.name == "tinymist" then
                                client = v
                                break
                            end
                        end

                        if not command then
                            print("Tinymist LSP not attached")
                            return
                        end

                        client.request(command, nil, function(err, _, _)
                            if err then
                                print("Error running command: " .. err)
                            end
                        end)
                    end, {
                        nargs = 1,
                        complete = function()
                            return {}
                        end,
                        desc = "Run Tinymist Commands"
                    })
                end,


                ["lua_ls"] = function()
                    local lspconfig = require("lspconfig")
                    lspconfig.lua_ls.setup {
                        capabilities = capabilities,
                        settings = {
                            Lua = {
                                runtime = { version = "Lua 5.1" },
                                diagnostics = {
                                    globals = { "bit", "vim", "it", "describe", "before_each", "after_each" },
                                }
                            }
                        }
                    }
                end,
            }

        })

        local l = vim.lsp

        l.handlers["textDocument/hover"] = function(_, result, ctx, config)
            config = config or { border = "rounded", focusable = true }
            config.focus_id = ctx.method
            if not (result and result.contents) then
                return
            end
            local markdown_lines = l.util.convert_input_to_markdown_lines(result.contents)
            markdown_lines = vim.tbl_filter(function(line)
                return line ~= ""
            end, markdown_lines)
            if vim.tbl_isempty(markdown_lines) then
                return
            end
            return l.util.open_floating_preview(markdown_lines, "markdown", config)
        end

        local cmp_select = { behavior = cmp.SelectBehavior.Select }
        vim.api.nvim_set_hl(0, "CmpNormal", {})
        cmp.setup({
            snippet = {
                expand = function(args)
                    require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
                end,
            },
            mapping = cmp.mapping.preset.insert({
                ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
                ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
                ['<C-y>'] = cmp.mapping.confirm({ select = true }),
                ['<C-e>'] = vim.NIL
            }),

            window = {
                completion = {
                    scrollbar = false,
                    border = "rounded",
                    winhighlight = "Normal:CmpNormal",
                },
                documentation = {
                    scrollbar = false,
                    border = "rounded",
                    winhighlight = "Normal:CmpNormal",
                }
            },
            sources = cmp.config.sources({
                {
                    name = "nvim_lsp",
                    max_item_count = 7,
                    entry_filter = function(entry, ctx)
                        return require("cmp").lsp.CompletionItemKind.Snippet ~= entry:get_kind()
                    end,
                },
                -- No need because I use autosnip
                { name = 'cmp-tw2css' },
                -- { name = 'luasnip' }, -- For luasnip users.
            }, {
                -- { name = 'buffer' },
            })
        })


        local autocmd = vim.api.nvim_create_autocmd

        autocmd({ "BufEnter", "BufWinEnter" }, {
            pattern = { "*.vert", "*.frag" },
            callback = function(e)
                vim.cmd("set filetype=glsl")
            end

        })



        autocmd('LspAttach', {
            callback = function(e)
                local opts = { buffer = e.buf }
                vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
                vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
                vim.keymap.set("n", "<leader>lf", vim.lsp.buf.format)
                vim.keymap.set("n", "<leader>la", function() vim.lsp.buf.code_action() end, opts)
                vim.keymap.set("n", "<leader>lr", function() vim.lsp.buf.rename() end, opts)
                vim.keymap.set("n", "<leader>k", function() vim.diagnostic.open_float() end, opts)
                vim.keymap.set("n", "<leader>ln", function() vim.diagnostic.goto_next() end, opts)
                vim.keymap.set("n", "<leader>lp", function() vim.diagnostic.goto_prev() end, opts)
                -- vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
                -- vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, opts)
                -- vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, opts)
            end
        })
    end
}
