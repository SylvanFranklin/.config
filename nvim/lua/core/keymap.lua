-- tab and space config

-- general
vim.g.mapleader = " "
vim.keymap.set('n', '<leader>h', ':set hlsearch!<CR>')
vim.keymap.set('n', '<leader>q', ':q<CR>')
vim.keymap.set('n', '<leader>w', ':w<CR>')
vim.keymap.set('n', '<leader>Q', ':wqa<CR>')
vim.keymap.set('n', '<leader>y', '"+y')
vim.keymap.set('v', '<leader>p', '"_dp')
-- close curent buffer
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
