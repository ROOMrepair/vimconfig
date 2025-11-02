return {
  {
    "folke/tokyonight.nvim",
    priority = 1000,
    lazy = false,
    enable = false,
  },
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,
    enable = false,
    priority = 1000,
    opts = {
      transparent_background = true,
      flavour = "auto",
      background = {
        light = "frappe",
        dark = "mocha",
      },
    },
  },
  {
    "bluz71/vim-moonfly-colors",
    name = "moonfly",
    lazy = false,
    priority = 1001,
    moonflyTransparent = true,
    init = function()
      local colors = {
        none = "none",

        black = "#170f12",
        white = "#edf1f2",
        lightgray = "#9da09c",
        gray = "#57646b",
        darkgray = "#2a2e2f",

        lightred = "#eba4a2",
        red = "#b72d29",
        darkred = "#2a0d12",

        lightblue = "#becaea",

        lightpurple = "#cbbbe5",

        lightorange = "#d29584",

        lightyellow = "#dac698",
      }
      local custom_highlight = vim.api.nvim_create_augroup("CustomHighlight", {})
      vim.api.nvim_create_autocmd("ColorScheme", {
        pattern = "moonfly",
        callback = function()
          vim.api.nvim_set_hl(0, "CursorLine", { bg = colors.none, bold = true })
          vim.api.nvim_set_hl(0, "CursorLineNr", { bg = colors.none, fg = colors.white })
        end,
        group = custom_highlight,
      })
    end,
  },
}
