return {
  "flash.nvim",
  keys = {
    { "<leader>z", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
    { "<leader>Z", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },

    { "f", mode = { "n", "x", "o" }, function() require("flash").jump({ mode = "char", search = { forward = true, wrap = false, multi_line = false } }) end },
    { "F", mode = { "n", "x", "o" }, function() require("flash").jump({ mode = "char", search = { forward = false, wrap = false, multi_line = false } }) end },
  },
  opts = {},
}
