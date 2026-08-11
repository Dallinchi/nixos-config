return {
  {
    "cachebag/nvim-tcss",

    ft = {
      "tcss",
    },

    after = function()
      require("tcss").setup()
    end,
  },
}
