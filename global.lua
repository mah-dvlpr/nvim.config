local global = {}

function global.map(mode, lhs, rhs, opts)
  local options = { noremap = true }
  if opts then
    options = vim.tbl_extend('force', options, opts)
  end
  vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

function global.map_buf(bufnr, mode, lhs, rhs, opts)
  local options = { noremap = true }
  if opts then
    options = vim.tbl_extend('force', options, opts)
  end
  vim.api.nvim_buf_set_keymap(bufnr, mode, lhs, rhs, options)
end

global.lsp_on_attach_opts = { noremap = true, silent = true }
global.lsp_on_attach_configs = {}

-- ================================================================
-- Custom 'Plugins'
function global.transp_bg(arg)
  local addr = '/org/gnome/terminal/legacy/profiles:/:b1dcc9dd-5262-4d8d-a863-c897e6d979b9/background-transparency-percent'

  if arg == '+' or arg == '-' then
    os.execute('dconf write ' .. addr .. ' $(($(dconf read ' .. addr .. ') ' .. arg .. '5))')
  elseif arg == 'color' then
    os.execute('dconf write ' .. addr .. ' ' .. 20)
    vim.g.vscode_transparent = 0
    vim.g.vscode_disable_nvimtree_bg = false
    vim.cmd([[colorscheme vscode]])
  elseif arg == 'transparent' then
    os.execute('dconf write ' .. addr .. ' ' .. 20)
    require('vscode')
    vim.g.vscode_transparent = 1
    vim.g.vscode_disable_nvimtree_bg = true
    vim.cmd([[colorscheme vscode]])
  end
end

local opts = { noremap = true }
global.map('', '<C-Down>', "<cmd>lua require('global').transp_bg('-')<cr>", opts)
global.map('', '<C-Up>', "<cmd>lua require('global').transp_bg('+')<cr>", opts)
global.map('', '<C-Left>', "<cmd>lua require('global').transp_bg('color')<cr>", opts)
global.map('', '<C-Right>', "<cmd>lua require('global').transp_bg('transparent')<cr>", opts)

return global

