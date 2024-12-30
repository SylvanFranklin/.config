-- general
vim.g.mapleader = " "
vim.keymap.set("n", "<leader>h", ":set hlsearch!<CR>")
vim.keymap.set("n", "<leader>q", ":q<CR>")
vim.keymap.set("n", "<leader>w", ":w<CR>")
vim.keymap.set({ "n", "v" }, "<leader>y", '"+y')
vim.keymap.set({ "n", "v" }, "<leader>d", '"+d')

-- plugin
vim.keymap.set({ "n", "x" }, "<leader>e", ":Oil<CR>", { silent = true })
-- vim.keymap.set({ "n", "x" }, "<C-L>", ":Lazy<CR>", { silent = true })
-- vim.keymap.set({ "n", "x" }, "<C-M>", ":Mason<CR>", { silent = true })

-- totally remove mouse, and arrow keys
-- vim.opt.mouse = ""
-- vim.keymap.set({ "n", "x", "v" }, "<up>", "<nop>")
-- vim.keymap.set({ "n", "x", "v" }, "<down>", "<nop>")
-- vim.keymap.set({ "n", "x", "v" }, "<left>", "<nop>")
-- vim.keymap.set({ "n", "x", "v" }, "<right>", "<nop>")

function toggle_aesthetic()
    -- function that toggles the aesthetic of the editor, goes into zen mode
    require("zen-mode").toggle({
        window = {
            backdrop = 1, -- shade the backdrop of the Zen window. Set to 1 to keep the same as Normal
            width = 0.85, -- width of the Zen window
            height = 0.9, -- height of the Zen window
            -- by default, no options are changed for the Zen window
            -- uncomment any of the options below, or add other vim.wo options you want to apply
            -- options = {
            --     signcolumn = "no",     -- disable signcolumn
            --     number = true,         -- disable number column
            --     relativenumber = true, -- disable relative numbers
            --     cursorline = false,    -- disable cursorline
            --     cursorcolumn = false,  -- disable cursor column
            --     foldcolumn = "0",      -- disable fold column
            --     list = false,          -- disable whitespace characters
            -- },
        },

        plugins = {
            options = {
                enabled = true,
                ruler = false,   -- disables the ruler text in the cmd line area
                showcmd = false, -- disables the command in the last line of the screen
                laststatus = 0,  -- turn off the statusline in zen mode
            },
            tmux = { enabled = true }, -- disables the tmux statusline
        }

    })
end

vim.keymap.set("n", "<leader>u", ":lua toggle_aesthetic()<CR>")
