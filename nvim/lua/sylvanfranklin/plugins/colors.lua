return {
    "vague2k/vague.nvim",
    config = function()
        require("vague").setup({ transparent = true })
        vim.cmd("colorscheme vague")
        vim.cmd(":hi statusline guibg=NONE")
    end

    -- "rktjmp/lush.nvim",
    -- if you wish to use your own colorscheme:
    -- { dir = '/absolute/path/to/colorscheme', lazy = true },
}
