if vim.g.neovide then
    vim.o.guifont = "FiraCode Nerd Font:h18" -- text below applies for VimScript
    vim.g.neovide_padding_top = 20
    vim.g.neovide_padding_bottom = 20
    vim.g.neovide_padding_right = 20
    vim.g.neovide_padding_left = 20

    local alpha = function()
        return string.format("%x", math.floor(255 * vim.g.transparency or 0.8))
    end
    -- g:neovide_transparency should be 0 if you want to unify transparency of content and title bar.
    vim.g.neovide_transparency = 0
    vim.g.transparency = 1
    vim.g.neovide_background_color = "#23273A" .. alpha()

    vim.g.neovide_floating_blur_amount_x = 2.0
    vim.g.neovide_floating_blur_amount_y = 2.0
end
