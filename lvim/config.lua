--
-- THESE ARE EXAMPLE CONFIGS FEEL FREE TO CHANGE TO WHATEVER YOU WANT
--

-- loading snippets

require("luasnip.loaders.from_lua").load({ paths = "~/.config/nvim/LuaSnip/" })
local ls = require("luasnip")

lvim.sp.buffer_mappings.normal_mode = {}

vim.opt.mouse = ""
vim.g.copilot_assume_mapped = true
vim.g.copilot_no_tab_map = true
vim.api.nvim_set_keymap("i", "<C-o>", 'copilot#Accept("<CR>")', { silent = true, expr = true })


-- Disable man.lua for K key in normal mode
lvim.keys.normal_mode["K"] = { "<cmd>lua vim.lsp.buf.hover()<CR>", { noremap = true, silent = true } }

-- keymaps for turning disabling and enabling lsp
vim.api.nvim_set_keymap("n", "<leader>lo", "<cmd>LspStop<CR>", { silent = true })
vim.api.nvim_set_keymap("n", "<leader>lp", "<cmd>LspStart<CR>", { silent = true })

-- kemap for enabling and disabling copilot
vim.api.nvim_set_keymap("n", "<leader>gca", "<cmd>Copilot enable<CR>", { silent = true })
-- now one for disabling
vim.api.nvim_set_keymap("n", "<leader>gcd", "<cmd>Copilot disable<CR>", { silent = true })


ls.config.setup({
    enable_autosnippets = true,
    -- store_selection_keys = "<Tab>"
})
-- Define the key mappings for snippet navigation
-- vim.api.nvim_set_keymap('i', 'kk', [[luasnip#expand_or_jumpable() ? '<Plug>luasnip-expand-or-jump' : '<CR>']],
--   { noremap = true, expr = true, silent = true })
-- vim.api.nvim_set_keymap('s', 'kk', [[luasnip#expand_or_jumpable() ? '<Plug>luasnip-expand-or-jump' : '<CR>']],
--   { noremap = true, expr = true, silent = true })


-- general
lvim.log.level = "warn"
lvim.format_on_save.enabled = false
lvim.colorscheme = "catppuccin"
-- lvim.colorscheme = "catppuccin-frappe"
-- lvim.colorscheme = "catppuccin-mocha"
-- lvim.colorscheme = "catppuccin-latte"
-- lvim.colorscheme = "catppuccin-macchiato"

-- to disable icons and use a minimalist setup, uncomment the following
-- lvim.use_icons = false


-- keymappings [view all the defaults by pressing <leader>Lk]
--
lvim.leader = "space"
lvim.transparent_window = true
-- add your own keymapping
lvim.builtin.autopairs.disable_in_macro = true
vim.opt.relativenumber = true
vim.opt.number = true


-- snippet expansion
-- vim.keymap.set('i', '<C-n>', 'copilot#Accept("<CR>")', {
--   expr = true,
--   replace_keycodes = false
-- })
--   vim.g.copilot_no_tab_map = true


--mapping

vim.api.nvim_set_keymap("n", "<C-o>", ":VimtexCompile<CR>:!zathura %:r.pdf<CR>", {})
-- this fixes the weird cursor
lvim.keys.insert_mode["<A-j>"] = false
lvim.keys.insert_mode["<A-k>"] = false
lvim.keys.normal_mode["<A-j>"] = false
lvim.keys.normal_mode["<A-k>"] = false
lvim.keys.visual_block_mode["<A-j>"] = false
lvim.keys.visual_block_mode["<A-k>"] = false
lvim.keys.visual_block_mode["J"] = false
lvim.keys.visual_block_mode["K"] = false
vim.opt.clipboard = ""
lvim.keys.normal_mode["<C-s>"] = ":w<cr>"
-- lvim.keys.normal_mode["<S-l>"] = ":BufferLineCycleNext<CR>"
-- lvim.keys.normal_mode["<S-h>"] = ":BufferLineCyclePrev<CR>"
-- unmap a default keymapping
-- vim.keymap.del("n", "<C-Up>")
-- override a default keymapping
-- lvim.keys.normal_mode["<C-q>"] = ":q<cr>" -- or vim.keymap.set("n", "<C-q>", ":q<cr>" )


lvim.builtin.telescope.defaults.file_ignore_patterns = {
    "%.git/",
    "node_modules/",
    "%.jpg",
    "%.jpeg",
    "%.png",
    "%.gif",
    "%.woff",
    "%.woff2",
    "%.ttf",
    "%.otf",
    "%.pdf",
    "%.exe",
    "%.zip",
    "%.tar.gz",
    "%.mkv",
    "%.mp4",
    "%.avi",
    "/dist/",
    "%.lock",
    "%.jsonc?",
    "%.config.json",
    "%.log",
    "%.cache",
    "%.bak",
    "%.swp",
    "%.swo",
    "%.swn",
    "yarn.lock",
    "package%-lock.json",
    "%.solid",
    "src%-tauri/target/",
    "src%-tauri/icons/",
    "%.svelte%-kit",
    "%.firebase",
}

lvim.builtin.telescope.defaults.find_command = { 'rg', '--files', '--hidden', '--exclude', '*.node' }




-- Change Telescope navigation to use j and k for navigation and n and p for history in both input and normal mode.
-- we use protected-mode (pcall) just in case the plugin wasn't loaded yet.
-- local _, actions = pcall(require, "telescope.actions")
-- lvim.builtin.telescope.defaults.mappings = {
--   -- for input mode
--   i = {
--     ["<C-j>"] = actions.move_selection_next,
--     ["<C-k>"] = actions.move_selection_previous,
--     ["<C-n>"] = actions.cycle_history_next,
--     ["<C-p>"] = actions.cycle_history_prev,
--   },
--   -- for normal mode
--   n = {
--     ["<C-j>"] = actions.move_selection_next,
--     ["<C-k>"] = actions.move_selection_previous,
--   },
-- }

-- Change theme settings
-- lvim.builtin.theme.options.dim_inactive = true
-- lvim.builtin.theme.options.style = "storm"

-- Use which-key to add extra bindings with the leader-key prefix
-- lvim.builtin.which_key.mappings["P"] = { "<cmd>Telescope projects<CR>", "Projects" }
-- lvim.builtin.which_key.mappings["t"] = {
--   name = "+Trouble",
--   r = { "<cmd>Trouble lsp_references<cr>", "References" },
--   f = { "<cmd>Trouble lsp_definitions<cr>", "Definitions" },
--   d = { "<cmd>Trouble document_diagnostics<cr>", "Diagnostics" },
--   q = { "<cmd>Trouble quickfix<cr>", "QuickFix" },
--   l = { "<cmd>Trouble loclist<cr>", "LocationList" },
--   w = { "<cmd>Trouble workspace_diagnostics<cr>", "Workspace Diagnostics" },
-- }

-- TODO: User Config for predefined plugins
-- After changing plugin config exit and reopen LunarVim, Run :PackerInstall :PackerCompile
lvim.builtin.alpha.active = true
lvim.builtin.alpha.mode = "dashboard"
lvim.builtin.terminal.active = true
lvim.builtin.nvimtree.setup.view.side = "left"
lvim.builtin.nvimtree.setup.renderer.icons.show.git = false

-- install without yarn or npm


-- disable <C-n> and <C-p> for completion

-- if you don't want all the parsers change this to a table of the ones you want
lvim.builtin.treesitter.ensure_installed = {
    "bash",
    "c",
    "javascript",
    "json",
    "lua",
    "python",
    "typescript",
    "tsx",
    "css",
    "rust",
    "java",
    "yaml",
    "svelte"
}

lvim.builtin.treesitter.ignore_install = { "haskell" }
lvim.builtin.treesitter.highlight.enable = true

-- generic LSP settings

-- -- make sure server will always be installed even if the server is in skipped_servers list
-- lvim.lsp.installer.setup.ensure_installed = {
--     "sumneko_lua",
--     "jsonls",
-- }
-- -- change UI setting of `LspInstallInfo`
-- -- see <https://github.com/williamboman/nvim-lsp-installer#default-configuration>
-- lvim.lsp.installer.setup.ui.check_outdated_servers_on_open = false
-- lvim.lsp.installer.setup.ui.border = "rounded"
-- lvim.lsp.installer.setup.ui.keymaps = {
--     uninstall_server = "d",
--
--     toggle_server_expand = "o",
-- }



-- ---@usage disable automatic installation of servers
-- lvim.lsp.installer.setup.automatic_installation = false

-- ---configure a server manually. !!Requires `:LvimCacheReset` to take effect!!
-- ---see the full default list `:lua print(vim.inspect(lvim.lsp.automatic_configuration.skipped_servers))`
-- vim.list_extend(lvim.lsp.automatic_configuration.skipped_servers, { "pyright" })
-- local opts = {} -- check the lspconfig documentation for a list of all possible options
-- require("lvim.lsp.manager").setup("pyright", opts)

-- ---remove a server from the skipped list, e.g. eslint, or emmet_ls. !!Requires `:LvimCacheReset` to take effect!!
-- ---`:LvimInfo` lists which server(s) are skipped for the current filetype
-- lvim.lsp.automatic_configuration.skipped_servers = vim.tbl_filter(function(server)
--   return server ~= "emmet_ls"
-- end, lvim.lsp.automatic_configuration.skipped_servers)

-- -- you can set a custom on_attach function that will be used for all the language servers
-- -- See <https://github.com/neovim/nvim-lspconfig#keybindings-and-completion>
-- lvim.lsp.on_attach_callback = function(client, bufnr)
--   local function buf_set_option(...)
--     vim.api.nvim_buf_set_option(bufnr, ...)
--   end
--   --Enable completion triggered by <c-x><c-o>
--   buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")
-- end

-- -- set a formatter, this will override the language server formatting capabilities (if it exists)
local formatters = require "lvim.lsp.null-ls.formatters"
formatters.setup {
    {
        name = "prettier",
        filetypes = { "typescript", "typescriptreact", "typescript", "javascript" },
    },
    { command = "latexindent", filetypes = { "tex" } },
    { exe = "black",           filetypes = { "python" } },
}

-- -- set additional linters
-- local linters = require "lvim.lsp.null-ls.linters"
-- linters.setup {
--   { command = "flake8", filetypes = { "python" } },
--   {
--     -- each linter accepts a list of options identical to https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/doc/BUILTINS.md#Configuration
--     command = "shellcheck",
--     ---@usage arguments to pass to the formatter
--     -- these cannot contain whitespaces, options such as `--line-width 80` become either `{'--line-width', '80'}` or `{'--line-width=80'}`
--     extra_args = { "--severity", "warning" },
--   },
--   {
--     command = "codespell",
--     ---@usage specify which filetypes to enable. By default a providers will attach to all the filetypes it supports.
--     filetypes = { "javascript", "python" },
--   },
-- }


-- Additional Plugins
lvim.plugins = {
    -- {
    --   "iamcco/markdown-preview.nvim",
    --   run = function() vim.fn["mkdp#util#install"]() end,
    -- },
    {
        "iamcco/markdown-preview.nvim",
        run = "cd app && npm install",
        setup = function()
            vim.g.mkdp_filetypes = {
                "markdown"
            }
        end,
        ft = { "markdown" },
    },
    {
        "lervag/vimtex",
        config = function()
            -- Viewer options
            vim.g.vimtex_view_method = "zathura" -- or your preferred PDF viewer
            -- Compiler method
            vim.g.vimtex_compiler_method = "latexmk" -- or your preferred LaTeX compiler method
        end
    },
    -- {"sirver/ultisnips", config = function()
    --   vim.g.UltisnipsExpandTrigger = '<tab>'
    --   vim.g.UltisnipsJumpForwardTrigger = '<tab>'
    --   vim.g.UltisnipsJumpBackwardTrigger = '<s-tab>'
    -- end},
    { "catppuccin/nvim",   as = "catppuccin" },
    { "github/copilot.vim" }
    -- { "evesdropper/luasnip-latex-snippets.nvim" }
}


-- Treesitter
-- ~/.config/lvim/config.lua

-- Additional Plugins
-- lvim.plugins = {
--   { 'nvim-treesitter/nvim-treesitter-textobjects' },
-- }

-- -- Treesitter
local ts = lvim.builtin.treesitter
ts.textobjects = {
    select = {
        enable = true,
        -- Automatically jump forward to textobj, similar to targets.vim
        lookahead = true,
        keymaps = {
            -- You can use the capture groups defined in textobjects.scm
            ["af"] = "@function.outer",
            ["if"] = "@function.inner",
            ["ac"] = "@class.outer",
            ["ic"] = "@class.inner",
        },
    },
    swap = {
        enable = false,
        -- swap_next = textobj_swap_keymaps,
    },
}
-- Autocommands (https://neovim.io/doc/user/autocmd.html)
--
--
-- vim.api.nvim_create_autocmd("BufEnter", {
--   pattern = { "*.json", "*.jsonc" },
--   -- enable wrap mode for json files only
--   command = "setlocal wrap",
-- })
-- vim.api.nvim_create_autocmd("FileType", {
--   pattern = "zsh",
--   callback = function()
--     -- let treesitter use bash highlight for zsh files as well
--     require("nvim-treesitter.highlight").attach(0, "bash")
--   end,
-- })
-- Load required plugins
--
--
-- Load required plugins
-- Configure keybindings
--
--
--
-- Set keybinds for both INSERT and VISUAL.
-- Set keybinds for both INSERT and VISUAL to jump to the next snippet node with Tab.
--
--
-- treesitter is buggy :(
-- lvim.builtin.teesitter.indent = { enable = true, disable = { "python" } }
