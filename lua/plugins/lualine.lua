return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
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
    local themes = {
      normal = {
        a = { bg = colors.lightblue, fg = colors.gray, gui = "bold" },
        b = { bg = colors.darkgray, fg = colors.lightgray },
        c = { bg = colors.none, fg = colors.lightgray },
      },
      insert = {
        a = { bg = colors.lightred, fg = colors.gray, gui = "bold" },
        b = { bg = colors.darkgray, fg = colors.lightgray },
        c = { bg = colors.none, fg = colors.lightgray },
      },
      visual = {
        a = { bg = colors.lightpurple, fg = colors.gray, gui = "bold" },
        b = { bg = colors.darkgray, fg = colors.lightgray },
        c = { bg = colors.none, fg = colors.lightgray },
      },
      replace = {
        a = { bg = colors.lightorange, fg = colors.gray, gui = "bold" },
        b = { bg = colors.darkgray, fg = colors.lightgray },
        c = { bg = colors.none, fg = colors.lightgray },
      },
      command = {
        a = { bg = colors.lightyellow, fg = colors.gray, gui = "bold" },
        b = { bg = colors.darkgray, fg = colors.lightgray },
        c = { bg = colors.none, fg = colors.lightgray },
      },
      inactive = {
        a = { fg = "NONE", bg = "NONE" },
        b = { fg = "NONE", bg = "NONE" },
        c = { fg = "NONE", bg = "NONE" },
      },
    }
    local function NULL()
      return [[]]
    end
    require("lualine").setup({
      options = {
        icons_enabled = true,
        theme = themes,
        component_separators = { left = "", right = "" },
        section_separators = { left = "", right = "" },
        -- component_separators = {},
        -- section_separators = {},
        disabled_filetypes = {
          statusline = { "dashboard", "alpha" },
          winbar = {},
        },
        ignore_focus = {},
        always_divide_middle = true,
        always_show_tabline = true,
        globalstatus = true,
        refresh = {
          statusline = 1000,
          tabline = 1000,
          winbar = 1000,
          refresh_time = 16, -- ~60fps
          events = {
            "WinEnter",
            "BufEnter",
            "BufWritePost",
            "SessionLoadPost",
            "FileChangedShellPost",
            "VimResized",
            "Filetype",
            "CursorMoved",
            "CursorMovedI",
            "ModeChanged",
          },
        },
      },
      sections = {
        lualine_a = { { "mode", separator = { left = "", right = "" }, right_padding = 2 } },
        lualine_b = { "branch", "diff", "diagnostics" },
        lualine_c = { "filename" },
        lualine_x = {
          { "encoding", separator = { right = "" } },
          { "filetype", icon_only = true, separator = { left = "" } },
        },
        lualine_y = {},
        lualine_z = { "progress", { "location", separator = { right = "" } } },
      },
      inactive_sections = {
        lualine_a = { { NULL, separator = { left = "", right = "" } } },
        lualine_b = {},
        lualine_c = {
          { "%=", separator = { left = "", right = "" } },
          { "filename", separator = { left = "", right = "" } },
          { "location", separator = { left = "", right = "" } },
        },
        lualine_x = {},
        lualine_y = {},
        lualine_z = { { NULL, separator = { left = "", right = "" } } },
      },
      tabline = {},
      winbar = {},
      inactive_winbar = {},
      extensions = {},
    })
  end,
}
