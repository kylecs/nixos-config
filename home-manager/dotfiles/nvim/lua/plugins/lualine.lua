return {
  {
    "nvim-lualine/lualine.nvim",
    opts = {
      sections = {
        lualine_z = {
          function()
            return "" -- this is usually time, but I'll have this in tmux already
          end,
        },
      },
    },
  },
}
