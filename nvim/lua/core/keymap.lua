function _G.format()
    -- runs :Format if the file type is typest, and otherfise uses the normal vim formatting
    if vim.fn.expand("%:e") == "typ" then
        -- make this line silent
        vim.cmd(":Format <CR>")
    else
        vim.cmd("lua vim.lsp.buf.format({async = true})")
    end
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
vim.keymap.set("n", "<leader>h", ":set hlsearch!<CR>")
vim.keymap.set("n", "<leader>q", ":q<CR>")
vim.keymap.set("n", "<leader>w", ":w<CR>")
vim.keymap.set("n", "<leader>Q", ":wqa<CR>")
vim.keymap.set("n", "<leader>y", '"+y')
-- close current buffer
vim.keymap.set("n", "<leader>c", ":bd<CR>")

-- telescope
vim.keymap.set("n", "<leader>f", ":Telescope find_files<CR>")
vim.keymap.set("n", "<leader>g", ":Telescope live_grep<CR>")
vim.keymap.set("n", "<leader>r", ":Telescope oldfiles<CR>")
vim.keymap.set("n", "<leader>b", ":Telescope buffers<CR>")

-- lsp commands
vim.keymap.set({ "n", "x" }, "<leader>lf", ":lua format()<CR>", { silent = true })
vim.keymap.set({ "n", "x" }, "<leader>lq", ":Trouble diagnostics toggle focus=true filter.buf=0<CR>")
vim.keymap.set({ "n", "x" }, "<leader>e", ":Oil<CR>")



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
vim.keymap.set("n", "<leader>p", ":lua preview()<CR>")

-- copilot keymaps
vim.keymap.set("n", "<leader>ce", ":Copilot enable<CR>")
vim.keymap.set("n", "<leader>cd", ":Copilot disable<CR>")
