vim.cmd("let g:vimtex_view_method = 'zathura'")

function _G.open_zathura()
    if vim.fn.expand("%:e") ~= "tex" then
        print("Not a .tex file")
        return
    end

    local file = vim.fn.expand("%")
    file = file:gsub(".tex", ".pdf")

    if vim.fn.filereadable(file) == 0 then
        print("No pdf file found")
        return
    end

    vim.fn.jobstart({ "zathura", file }, { detach = true })
end

-- keybindings
vim.api.nvim_set_keymap("n", "<leader>z", "<cmd>lua open_zathura()<cr>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>vc", "<cmd>VimtexCompile<cr>", { noremap = true, silent = true })

