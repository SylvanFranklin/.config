-- tab and space config

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
vim.keymap.set('n', '<leader>h', ':set hlsearch!<CR>')
vim.keymap.set('n', '<leader>q', ':q<CR>')
vim.keymap.set('n', '<leader>w', ':w<CR>')
vim.keymap.set('n', '<leader>Q', ':wqa<CR>')
vim.keymap.set('n', '<leader>y', '"+y')
-- close current buffer
vim.keymap.set('n', '<leader>c', ':bd<CR>')

-- telescope
vim.keymap.set('n', '<leader>f', ':Telescope find_files<CR>')
vim.keymap.set('n', '<leader>g', ':Telescope git_files<CR>')
vim.keymap.set('n', '<leader>t', ':Telescope live_grep<CR>')
vim.keymap.set('n', '<leader>r', ':Telescope oldfiles<CR>')
vim.keymap.set('n', '<leader>b', ':Telescope buffers<CR>')

-- lsp commands
vim.keymap.set({ 'n', 'x' }, '<leader>lf', '<cmd>lua vim.lsp.buf.format({async = true})<cr>', opts)
vim.keymap.set({ 'n', 'x' }, '<leader>lq', ':Trouble<CR>')
vim.keymap.set({ 'n', 'x' }, '<leader>e', ':Oil<CR>')

-- code runner
vim.keymap.set('n', '<leader><cr>', ':RunCode<CR>')


-- totally remove mouse
vim.opt.mouse = ""

-- unmap all the arrow keys, to prevent normy use
vim.keymap.set({ 'n', 'x', 'v' }, '<up>', '<nop>');
vim.keymap.set({ 'n', 'x', 'v' }, '<down>', '<nop>');
vim.keymap.set({ 'n', 'x', 'v' }, '<left>', '<nop>');
vim.keymap.set({ 'n', 'x', 'v' }, '<right>', '<nop>');

-- preview functions
vim.keymap.set('n', '<leader>p', ':lua preview()<CR>')

