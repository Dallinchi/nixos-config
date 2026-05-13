return {
  "flash.nvim",

  opts = {},
  keys = {
    { "<leader>z", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
    { "<leader>Z", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
  },

}
