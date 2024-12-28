return {
    'hat0uma/csvview.nvim',
    config = function()
        require('csvview').setup(
            {
                view = {
                    -- min_column_width = 5,
                    spacing = 2,
                    display_mode = "border",
                },
            }
        )
    end
}
