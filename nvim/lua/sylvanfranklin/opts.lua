vim.opt.guicursor = ""
vim.opt.mouse = ""
vim.opt.tabstop = 4
vim.opt.guicursor = "n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20"
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.smartindent = false
vim.opt.expandtab = true
vim.opt.wrap = false
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.swapfile = false
vim.opt.termguicolors = true
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.ignorecase = true
vim.opt.undofile = true
vim.opt.incsearch = true
vim.opt.hlsearch = false
vim.opt.scrolloff = 4
vim.opt.signcolumn = "yes"
vim.opt.foldopen = "mark,percent,quickfix,search,tag,undo"

local gdproject = io.open(vim.fn.getcwd() .. '/project.godot', 'r')
if gdproject then
    io.close(gdproject)
    vim.fn.serverstart './godothost'
end
