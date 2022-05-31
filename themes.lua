local global = require('global')

local vscode = {
  config = function()
    vim.o.background = 'dark'
    vim.g.vscode_transparent = 1
    vim.g.vscode_italic_comment = 1
    vim.g.vscode_disable_nvimtree_bg = true
    vim.cmd([[colorscheme vscode]])
  end,
}

return { vscode = vscode }
