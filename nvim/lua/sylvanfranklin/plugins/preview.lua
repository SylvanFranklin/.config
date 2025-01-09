return {
    {
        "toppair/peek.nvim",
        event = { "VeryLazy" },
        build = "deno task --quiet build:fast",
        config = function()
            require("peek").setup({ app = "browser" })
            vim.api.nvim_create_user_command("PeekOpen", require("peek").open, {})
            vim.api.nvim_create_user_command("PeekClose", require("peek").close, {})
        end
    },
    {
        'chomosuke/typst-preview.nvim',
        version = '1.*',
        config = function()
            require 'typst-preview'.setup {
                -- Setting this true will enable logging debug information to
                -- `vim.fn.stdpath 'data' .. '/typst-preview/log.txt'`
                debug = false,

                -- Custom format string to open the output link provided with %s
                -- Example: open_cmd = 'firefox %s -P typst-preview --class typst-preview'
                open_cmd = nil,

                -- Setting this to 'always' will invert black and white in the preview
                -- Setting this to 'auto' will invert depending if the browser has enable
                -- dark mode
                -- Setting this to '{"rest": "<option>","image": "<option>"}' will apply
                -- your choice of color inversion to images and everything else
                -- separately.
                invert_colors = 'never',

                -- Whether the preview will follow the cursor in the source file
                follow_cursor = true,

                -- Provide the path to binaries for dependencies.
                -- Setting this will skip the download of the binary by the plugin.
                -- Warning: Be aware that your version might be older than the one
                -- required.
                dependencies_bin = {
                    ['tinymist'] = "/Users/sylvanfranklin/.cargo/bin/tinymist",
                    ['websocat'] = nil
                },

                -- A list of extra arguments (or nil) to be passed to previewer.
                -- For example, extra_args = { "--input=ver=draft", "--ignore-system-fonts" }
                extra_args = nil,

                -- This function will be called to determine the root of the typst project
                get_root = function(path_of_main_file)
                    local root = os.getenv 'TYPST_ROOT'
                    if root then
                        return root
                    end
                    return vim.fn.fnamemodify(path_of_main_file, ':p:h')
                end,

                -- This function will be called to determine the main file of the typst
                -- project.
                get_main_file = function(path_of_buffer)
                    return path_of_buffer
                end,
            }
            vim.keymap.set("n", "<leader>p", ":TypstPreview<CR>")
        end,
    }
}
