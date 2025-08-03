if vim.g.vscode then
  return {}
else
  return {
    "nvim-treesitter/nvim-treesitter",
    branch = "master",
    lazy = false,
    build = ":TsUpdate",
    cmd = { "TSUpdateSync", "TSUpdate", "TSInstall" },
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = {
          "c",
          "cpp",
          "cmake",
          "html",
          "json",
          "lua",
          "vim",
          "vimdoc",
          "query",
          "markdown",
          "markdown_inline",
        },
        modules = {},
        sync_install = false,
        auto_install = true,
        ignore_install = {},
        highlight = {
          enable = true,
        },
      })
      vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
    end,
  }
end
