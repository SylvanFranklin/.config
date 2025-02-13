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
        "hrsh7th/nvim-cmp",
    },


    config = function()
        local util = require 'lspconfig.util'
        vim.diagnostic.config({
            float = { border = "rounded" }
        })

        -- local function client_with_fn(fn)
        --     return function()
        --         local bufnr = vim.api.nvim_get_current_buf()
        --         local client = util.get_active_client_by_name(bufnr, 'tinymist')
        --         if not client then
        --             return vim.notify(('tinymist client not found %d'):format(bufnr), vim.log.levels.ERROR)
        --         end
        --         fn(client, bufnr)
        --     end
        -- end
        --
        -- local function Preview(client, bufnr)
        --     local buf_name = vim.api.nvim_buf_get_name(bufnr)
        --     if buf_name == "" then
        --         return vim.notify("No file associated with the current buffer", vim.log.levels.ERROR)
        --     end
        --
        --     -- Log the command being sent
        --     print("Executing command:", vim.inspect({
        --         command = "tinymist.doStartPreview",
        --         arguments = { { buf_name } },
        --     }))
        --
        --     local success, err = pcall(function()
        --         vim.lsp.buf.execute_command({
        --             command = "tinymist.doStartPreview",
        --             arguments = { { "--partial-rendering", buf_name } },
        --         })
        --     end)
        --
        --     if not success then
        --         vim.notify("Failed to execute command: " .. err, vim.log.levels.ERROR)
        --     else
        --         vim.notify("Command sent successfully!", vim.log.levels.INFO)
        --     end
        -- end
        --
        -- local function Export(client, bufnr)
        --     vim.lsp.buf.execute_command {
        --         command = 'tinymist.exportPng',
        --         arguments = {
        --             vim.api.nvim_buf_get_name(0)
        --             -- position = { line = pos[1] - 1, character = pos[2] },
        --             -- newName = tostring(new),
        --             -- lua = vim.lsp.get_clients()[1].server_capabilities
        --         },
        --     }
        --     -- vim.notify('Preview Started', vim.log.levels.INFO)
        -- end

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
                "lua_ls",
                "rust_analyzer",
                "tinymist",
                "glsl_analyzer"
            },
            handlers = {
                -- handles default behavior
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
                                    -- Here use ctx.match instead of ctx.file
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

                    local tinymist_commands = {
                        "doClearCache",
                        "doGetTemplateEntry",
                        "doInitTemplate",
                        "doKillPreview",
                        "doStartPreview",
                        "focusMain",
                        "getDocumentMetrics",
                        "getDocumentTrace",
                        "getResources",
                        "getServerInfo",
                        "getWorkspaceLabels",
                        "interactCodeContext",
                        "pinMain",
                        "scrollPreview",
                        "exportHtml",
                        "exportMarkdown",
                        "exportPdf",
                        "exportPng",
                        "exportSvg",
                        "exportText",
                    }

                    vim.api.nvim_create_user_command("Tinymist", function(opts)
                        local sub = opts.args
                        local command = "tinymist." .. sub
                        vim.lsp.buf.execute_command {
                            command = command,
                            arguments = {
                                vim.api.nvim_buf_get_name(0)
                            }
                        }
                    end, {
                        nargs = 1,
                        complete = function()
                            return tinymist_commands
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
                vim.keymap.set("n", "<leader>lk", function() vim.diagnostic.open_float() end, opts)
                vim.keymap.set("n", "<leader>ln", function() vim.diagnostic.goto_next() end, opts)
                vim.keymap.set("n", "<leader>lp", function() vim.diagnostic.goto_prev() end, opts)
                -- vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
                -- vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, opts)
                -- vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, opts)
            end
        })
    end
}
