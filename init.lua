-- ================================================================
-- Include global modules
package.path = vim.fn.stdpath('config') .. '/?.lua;' -- Will be set for all other included modules via require
local global = require('global')

-- ================================================================
-- (Neo)Vim options
vim.opt.clipboard = 'unnamedplus' -- Enable system clipboard
vim.opt.syntax = 'on' -- Enable syntax linting (not needed with an LSP?)
vim.opt.termguicolors = true -- Use true colors, instead oluf just usual 256-bit colors.
vim.opt.wrap = false -- Do not wrap lines, plain and simple.
vim.opt.number = true -- Absolute numbering.
vim.opt.cursorline = true -- Highlight current line.
vim.opt.list = true -- Render special characters such as whitespace and TAB's.
vim.opt.listchars = 'tab:> ,space:·' -- Render whitespace as '·'.
vim.opt.expandtab = true -- Expand TABs into spaces when tabbing.
vim.opt.shiftwidth = 4 -- Set amount of whitespace characters to insert/remove when tabbing/backspace.
vim.opt.tabstop = 4 -- Length of an actual TAB, i.e. not whitespace(s).
vim.opt.softtabstop = 4 -- I have no idea what this does.
vim.opt.backspace = 'start,indent,eol' -- Allow performing backspace over (almost) everything in insert mode.
vim.opt.mouse = 'a' -- DON'T JUDGE ME! (allows mouse support in all modes).
vim.opt.scrolloff = 16 -- Keep cursor centered by making the pre/post buffer padding very large.
vim.opt.hidden = true -- Keep buffers open when switching between files.
vim.g.mapleader = 'ö'
vim.cmd[[au ColorScheme * hi Normal ctermbg=none guibg=none]]
vim.cmd[[au ColorScheme * hi NonText ctermbg=none guibg=none]]
--vim.cmd[[colorscheme slate]]

-- ================================================================
-- Custom keymaps
global.map('', 'J', '8j', { noremap = true })
global.map('', 'K', '8k', { noremap = true })

-- ================================================================
-- Plugins
local install_path = vim.fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
local packer_bootstrap
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  packer_bootstrap = vim.fn.system({ 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path })
end

vim.cmd [[packadd packer.nvim]]
require('packer').startup(function()
  use {
    'wbthomason/packer.nvim'
  }

  use {
    'williamboman/nvim-lsp-installer',
    {
      'neovim/nvim-lspconfig',
      config = require('nvim-lsp-installer').setup()
    }
  }

  use {
    'nvim-treesitter/nvim-treesitter',
    run = 'TSUpdate',
    setup = require('nvim-treesitter.configs').setup {
      ensure_installed = { 'c', 'lua', 'rust' },
      sync_install = false,
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
      },
    }
  }

  if packer_bootstrap then
    require('packer').sync()
  end
end)

-- ================================================================
-- nvim-lsp-installer - Has to be placed like this due to how this package works
require('nvim-lsp-installer').setup {
  automatic_installation = true, -- automatically detect which servers to install (based on which servers are set up via lspconfig)
  ui = {
    icons = {
      server_installed = '✓',
      server_pending = '➜',
      server_uninstalled = '✗'
    }
  }
}

-- ================================================================
-- lspconfig - Has to be placed like this due to nvim-lsp-installer
require('plugins/lspconfig').config()
