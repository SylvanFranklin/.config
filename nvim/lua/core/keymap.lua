function toggle_asthetic()
    -- function that toggles the asthetic of the editor, goes into zen mode
    require("zen-mode").toggle({
        window = {
            backdrop = 1, -- shade the backdrop of the Zen window. Set to 1 to keep the same as Normal
            width = 0.85, -- width of the Zen window
            height = 0.9, -- height of the Zen window
            -- by default, no options are changed for the Zen window
            -- uncomment any of the options below, or add other vim.wo options you want to apply
            options = {
                signcolumn = "no",      -- disable signcolumn
                number = true,         -- disable number column
                relativenumber = true, -- disable relative numbers
                cursorline = false,     -- disable cursorline
                cursorcolumn = false,   -- disable cursor column
                foldcolumn = "0",       -- disable fold column
                list = false,           -- disable whitespace characters
            },
        },

        plugins = {
            options = {
                enabled = true,
                ruler = false,   -- disables the ruler text in the cmd line area
                showcmd = false, -- disables the command in the last line of the screen
                laststatus = 0,  -- turn off the statusline in zen mode
            },
            -- gitsigns = { enabled = false }, -- disables git signs
            tmux = { enabled = true }, -- disables the tmux statusline
            -- todo = { enabled = false }, -- if set to "true", todo-comments.nvim highlights will be disabled
            alacritty = {
                enabled = false,
                font = "60", -- font size
            },
        }

    })
end

function _G.format()
    vim.cmd("lua vim.lsp.buf.format({async = true, silent=true})")
end

function run_code()
    -- check for rust and use cargo
    if vim.fn.expand("%:e") == "rs" then
        vim.fn.jobstart({ "cargo", "run" }, { detach = true })
    end
end

function _G.preview()
    -- function that determines the file type, and then opens the file in the correct viewer
    -- tex: zathura (pdf)
    -- md: uses :MarkdownPreviewToggle
    -- typst: user :TypstPreview
    if vim.fn.expand("%:e") == "tex" then
        vim.fn.jobstart({ "zathura", vim.fn.expand("%:r") .. ".pdf" }, { detach = true })
    elseif vim.fn.expand("%:e") == "md" then
        vim.cmd("MarkdownPreviewToggle")
    elseif vim.fn.expand("%:e") == "typ" then
        vim.cmd("TypstPreview")
    else
        print("No preview available for this file type")
    end
end

-- general
vim.g.mapleader = " "
vim.keymap.set("n", "<leader>u", ":lua toggle_asthetic()<CR>", { silent = true })
vim.keymap.set("n", "<leader>h", ":set hlsearch!<CR>")
vim.keymap.set("n", "<leader>q", ":q<CR>")
vim.keymap.set("n", "<leader>w", ":w<CR>")
vim.keymap.set({ "n", "v" }, "<leader>y", '"+y')
-- close current buffer

-- telescope
vim.keymap.set("n", "<leader>f", ":Telescope find_files<CR>", { silent = true })
vim.keymap.set("n", "<leader>g", ":Telescope live_grep<CR>", { silent = true })
vim.keymap.set("n", "<leader>r", ":Telescope oldfiles<CR>", { silent = true })
vim.keymap.set("n", "<leader>b", ":Telescope buffers<CR>", { silent = true })

-- lsp commands
vim.keymap.set({ "n", "x" }, "<leader>lf", ":lua format()<CR>", { silent = true })
vim.keymap.set({ "n", "x" }, "<leader>lq", ":Trouble diagnostics toggle focus=true filter.buf=0<CR>", { silent = true })
vim.keymap.set({ "n", "x" }, "<leader>e", ":Oil<CR>", { silent = true })


-- totally remove mouse, and arrow keys
vim.opt.mouse = ""
vim.keymap.set({ "n", "x", "v" }, "<up>", "<nop>")
vim.keymap.set({ "n", "x", "v" }, "<down>", "<nop>")
vim.keymap.set({ "n", "x", "v" }, "<left>", "<nop>")
vim.keymap.set({ "n", "x", "v" }, "<right>", "<nop>")

-- terminal config
-- TODO make this faster and smoother for running C++ code
-- vim.keymap.set({ "n", "x", "v" }, "<leader>t", ":botright vsp | term <CR>")
-- vim.keymap.set({ "n", "x", "v" }, "<leader><space>", ":lua run_code()<CR>")
vim.keymap.set("n", "<leader><cr>", ":RunCode<CR>")

-- preview functions
vim.keymap.set("n", "<leader>p", ":lua preview()<CR>", { silent = true })

-- copilot keymaps
vim.keymap.set("n", "<leader>ce", ":Copilot enable<CR>")
vim.keymap.set("n", "<leader>cd", ":Copilot disable<CR>")

-- sorting by dates (s-d)
vim.keymap.set({ "v", "x" }, "<leader>s", ":!sort -M<CR>")



-- :vnoremap i$ T$ot$
