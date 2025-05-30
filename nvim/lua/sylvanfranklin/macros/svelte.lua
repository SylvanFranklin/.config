vim.api.nvim_create_autocmd("BufEnter", {
    pattern = "*.svelte",
    callback = function()
        vim.fn.setreg('r', "diwAMath.floor(Math.random() * pa))")
        vim.fn.setreg('f', "0f\"s{`;s`}")
        vim.fn.setreg('s', "vatof>i class=\"\"i")
    end,
})
