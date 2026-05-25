return {
  "stevearc/conform.nvim",
  opts = function()
    local opts = {
      formatters_by_ft = {
        json = { "jq" },
        lua = { "stylua" },
        cpp = { "clang-format" },
        c = { "clang-format" },
        javascript = { "prettier" },
      },
    }
    return opts
  end,
}
