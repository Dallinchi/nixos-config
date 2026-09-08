return {
    "blink.cmp",
    lazy = false,

    before = function()
        require("blink.cmp").setup({
            keymap = {
                preset = "default",

                ["<Tab>"] = {
                    "select_next",
                    "fallback",
                },

                ["<S-Tab>"] = {
                    "select_prev",
                    "fallback",
                },

                ["<CR>"] = {
                    "accept",
                    "fallback",
                },
            },
        })
    end,
}

