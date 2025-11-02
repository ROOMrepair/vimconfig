return {
  {
    "mfussenegger/nvim-lint",
    opts = {
      linters_by_ft = {
        js = { "eslint" },
        ts = { "eslint" },
        jsx = { "eslint" },
        tsx = { "eslint" },
        vue = { "eslint" },
      },
    },
  },
}
