return {
    "comment.nvim",

    after = function()
        require("Comment").setup()

        vim.keymap.set("n", "<leader>/", function()
            require("Comment.api").toggle.linewise.current()
        end)

        vim.keymap.set("x", "<leader>/", function()
            vim.api.nvim_feedkeys(
                vim.api.nvim_replace_termcodes("gc", true, false, true),
                "x",
                false
            )
        end)
    end
}
