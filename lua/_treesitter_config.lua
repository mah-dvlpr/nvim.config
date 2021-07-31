require('nvim-treesitter.configs').setup {
    ensure_installed = {"bash", "c", "python"},

    highlight = { -- enable highlighting for all file types
      enable = true, -- you can also use a table with list of langs here (e.g. { "python", "javascript" })
    },
}
