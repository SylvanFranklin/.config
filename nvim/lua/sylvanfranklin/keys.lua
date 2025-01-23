-- general
vim.g.mapleader = " "
vim.keymap.set("n", "<leader>q", ":q<CR>")
vim.keymap.set("n", "<leader>w", "<CMD>write<CR>", { silent = true })
vim.keymap.set({ "n", "v" }, "<leader>y", '"+y')
vim.keymap.set({ "n", "v" }, "<leader>d", '"+d')

-- plugin
-- vim.keymap.set({ "n", "x" }, "<C-L>", ":Lazy<CR>", { silent = true })
-- vim.keymap.set({ "n", "x" }, "<C-M>", ":Mason<CR>", { silent = true })

-- totally remove mouse, and arrow keys
-- vim.opt.mouse = ""
-- vim.keymap.set({ "n", "x", "v" }, "<up>", "<nop>")
-- vim.keymap.set({ "n", "x", "v" }, "<down>", "<nop>")
-- vim.keymap.set({ "n", "x", "v" }, "<left>", "<nop>")
-- vim.keymap.set({ "n", "x", "v" }, "<right>", "<nop>")

function toggle_aesthetic()
    require("zen-mode").toggle({
        window = {
            backdrop = 1, -- shade the backdrop of the Zen window. Set to 1 to keep the same as Normal
            width = 1,    -- width of the Zen window
            height = 1,   -- height of the Zen window
            -- by default, no options are changed for the Zen window
            -- uncomment any of the options below, or add other vim.wo options you want to apply
            options = {
                signcolumn = "yes",     -- disable signcolumn
                number = false,         -- disable number column
                relativenumber = false, -- disable relative numbers
                cursorline = false,     -- disable cursorline
                cursorcolumn = false,   -- disable cursor column
                foldcolumn = "0",       -- disable fold column
                list = true,            -- disable whitespace characters
            },
        },

        plugins = {
            options = {
                enabled = true,
                ruler = false,         -- disables the ruler text in the cmd line area
                showcmd = false,       -- disables the command in the last line of the screen
                laststatus = 0,        -- turn off the statusline in zen mode
            },
            tmux = { enabled = true }, -- disables the tmux statusline
        }

    })
end

vim.keymap.set("n", "<leader>u", ":lua toggle_aesthetic()<CR>")

function jump_header()
    -- Get the full path of the current file
    -- local file = vim.fn.expand("%:p")
    local ext = vim.fn.expand("%:e")

    -- Define potential source and header file extensions
    local source_exts = { "cpp", "c" }
    local header_exts = { "h", "hpp", "hh" }

    -- Determine the new extension
    local target_exts = nil
    if vim.tbl_contains(header_exts, ext) then
        target_exts = source_exts
    elseif vim.tbl_contains(source_exts, ext) then
        target_exts = header_exts
    else
        print("Not a recognized C++ header or source file.")
        return
    end

    -- Attempt to find and open the counterpart file
    local base_name = vim.fn.expand("%:r")
    for _, target_ext in ipairs(target_exts) do
        local target_file = base_name .. "." .. target_ext
        if vim.fn.filereadable(target_file) == 1 then
            vim.cmd("edit " .. target_file)
            return
        end
    end

    print("Corresponding file not found.")
end

-- Key mapping to jump between header and source files
vim.keymap.set("n", "<leader>b", ":lua jump_header()<CR>", { silent = true })
