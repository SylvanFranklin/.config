return {
    "neovim/nvim-lspconfig",
    dependencies = {
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-cmdline",
        "hrsh7th/nvim-cmp",
        -- "L3MON4D3/LuaSnip",
        -- "saadparwaiz1/cmp_luasnip",
        -- formatter
        "stevearc/conform.nvim",
    },

    config = function()
        local util = require 'lspconfig.util'

        local function client_with_fn(fn)
            return function()
                local bufnr = vim.api.nvim_get_current_buf()
                local client = util.get_active_client_by_name(bufnr, 'tinymist')
                if not client then
                    return vim.notify(('tinymist client not found %d'):format(bufnr), vim.log.levels.ERROR)
                end
                fn(client, bufnr)
            end
        end

        local function Preview(client, bufnr)
            local buf_name = vim.api.nvim_buf_get_name(bufnr)
            if buf_name == "" then
                return vim.notify("No file associated with the current buffer", vim.log.levels.ERROR)
            end

            -- Log the command being sent
            print("Executing command:", vim.inspect({
                command = "tinymist.doStartPreview",
                arguments = { { buf_name } },
            }))

            local success, err = pcall(function()
                vim.lsp.buf.execute_command({
                    command = "tinymist.doStartPreview",
                    arguments = { { buf_name } },
                })
            end)

            if not success then
                vim.notify("Failed to execute command: " .. err, vim.log.levels.ERROR)
            else
                vim.notify("Command sent successfully!", vim.log.levels.INFO)
            end
        end

        local function Export(client, bufnr)
            vim.lsp.buf.execute_command {
                command = 'tinymist.exportPng',
                arguments = {
                    vim.api.nvim_buf_get_name(0)
                    -- position = { line = pos[1] - 1, character = pos[2] },
                    -- newName = tostring(new),
                    -- lua =vim.lsp.get_clients()[1].server_capabilities
                },
            }
            -- vim.notify('Preview Started', vim.log.levels.INFO)
        end

        require("conform").setup({
            formatters_by_ft = {
            }
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
                "lua_ls",
                "rust_analyzer",
                "tinymist"
            },
            handlers = {
                -- handles default behavior
                function(server_name)
                    require("lspconfig")[server_name].setup {
                        capabilities = capabilities
                    }
                end,

                -- other config stuff, tested to be correct
                ["tinymist"] = function()
                    require("lspconfig")["tinymist"].setup {
                        capabilities = capabilities,
                        settings = {
                            formatterMode = "typstyle"
                        },
                        commands = {
                            TypstPreview = {
                                client_with_fn(Preview),
                                description = 'Start the Live Preview',
                            },
                            ExportPng = {
                                client_with_fn(Export),
                                description = 'Start the Live Preview',
                            },
                        }
                    }
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

        local cmp_select = { behavior = cmp.SelectBehavior.Select }
        vim.api.nvim_set_hl(0, "CmpNormal", {})
        cmp.setup({
            -- snippet = {
            --     expand = function(args)
            --         require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
            --     end,
            -- },
            mapping = cmp.mapping.preset.insert({
                ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
                ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
                ['<C-y>'] = cmp.mapping.confirm({ select = true }),
                -- ["<C-Space>"] = cmp.mapping.complete(),
            }),

            window = {
                completion = {
                    border = "rounded",
                    winhighlight = "Normal:CmpNormal",
                }
            },

            sources = cmp.config.sources({
                { name = 'nvim_lsp' },
                -- { name = 'luasnip' }, -- For luasnip users.
            }, {
                { name = 'buffer' },
            })
        })

        local autocmd = vim.api.nvim_create_autocmd
        autocmd('LspAttach', {
            callback = function(e)
                local opts = { buffer = e.buf }
                vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
                vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
                vim.keymap.set("n", "p", ":TypstPreview<CR>", opts)
                vim.keymap.set("n", "<leader>lf", vim.lsp.buf.format)
                vim.keymap.set("n", "<leader>la", function() vim.lsp.buf.code_action() end, opts)
                vim.keymap.set("n", "<leader>lr", function() vim.lsp.buf.rename() end, opts)
                -- vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
                -- vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, opts)
                -- vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, opts)
            end
        })
    end
}
