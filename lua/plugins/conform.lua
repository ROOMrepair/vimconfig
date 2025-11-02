return {
  "stevearc/conform.nvim",
  opts = function()
    local opts = {
      formatters_by_ft = {
        json = { "jq" },
        lua = { "stylua" },
      },
    }
    return opts
  end,
}
