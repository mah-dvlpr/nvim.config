-- ================================================================
-- Custom (Neo)Vim definitions and declarations
local function map(mode, lhs, rhs, opts)
  local options = { noremap = true }
  if opts then
    options = vim.tbl_extend('force', options, opts)
  end
  vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

local function map_buf(bufnr, mode, lhs, rhs, opts)
  local options = { noremap = true }
  if opts then
    options = vim.tbl_extend('force', options, opts)
  end
  vim.api.nvim_buf_set_keymap(bufnr, mode, lhs, rhs, options)
end

local lsp_on_attach_opts = { noremap = true, silent = true }
local lsp_on_attach_configs = {}

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

-- ================================================================
-- Plugins
local install_path = vim.fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  packer_bootstrap = vim.fn.system({ 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path })
end

vim.cmd [[packadd packer.nvim]]
require('packer').startup(function()
  use {
    'wbthomason/packer.nvim'
  }

  use {
    'Mofiqul/vscode.nvim',
    config = function()
      vim.o.background = 'dark'
      vim.g.vscode_transparent = 1
      vim.g.vscode_italic_comment = 1
      vim.g.vscode_disable_nvimtree_bg = true
      vim.cmd([[colorscheme vscode]])
    end
  }

  use {
    'williamboman/nvim-lsp-installer',
    {
      'neovim/nvim-lspconfig',
      config = function()
        require('nvim-lsp-installer').setup {}
        local lspconfig = require('lspconfig')
      end
    }
  }

  use {
    'nvim-treesitter/nvim-treesitter',
    run = 'TSUpdate',
    setup = require('nvim-treesitter.configs').setup {
      -- A list of parser names, or 'all'
      ensure_installed = { 'c', 'lua', 'rust' },

      -- Install parsers synchronously (only applied to `ensure_installed`)
      sync_install = false,

      -- List of parsers to ignore installing (for 'all')
      ignore_install = { 'javascript' },

      highlight = {
        -- `false` will disable the whole extension
        enable = true,
        additional_vim_regex_highlighting = false,
      },
    }
  }

  require('packer').sync()
end)

-- ================================================================
-- nvim-lsp-installer
require('nvim-lsp-installer').setup({
  automatic_installation = true, -- automatically detect which servers to install (based on which servers are set up via lspconfig)
  ui = {
    icons = {
      server_installed = '✓',
      server_pending = '➜',
      server_uninstalled = '✗'
    }
  }
})

-- ================================================================
-- lspconfig
-- Mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  -- Generic mappings.
  map_buf(bufnr, 'n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>', lsp_on_attach_opts)
  map_buf(bufnr, 'n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', lsp_on_attach_opts)
  map_buf(bufnr, 'n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>', lsp_on_attach_opts)
  map_buf(bufnr, 'n', '<f2>', '<cmd>lua vim.lsp.buf.rename()<cr>', lsp_on_attach_opts)
  map_buf(bufnr, 'n', '<C-i>', '<cmd>lua vim.lsp.buf.code_action()<cr>', lsp_on_attach_opts)
  map_buf(bufnr, 'n', '<leader>f', '<cmd>lua vim.lsp.buf.formatting()<cr>', lsp_on_attach_opts)

  --  table.insert(lsp_on_attach_configs, function(client, bufnr)
  --    map_buf(bufnr, 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>', lsp_on_attach_opts)
  --    map_buf(bufnr, 'n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<cr>', lsp_on_attach_opts)
  --  end)

  -- Call registered handlers
  for callback in pairs(lsp_on_attach_configs) do
    callback(client, bufnr)
  end
end

-- Use a loop to conveniently call 'setup' on multiple servers and
-- map buffer local keybindings when the language server attaches
local servers = { 'sumneko_lua', 'rust_analyzer', 'clangd', 'dartls' }
for _, lsp in pairs(servers) do
  require('lspconfig')[lsp].setup {
    on_attach = on_attach,
  }
end

-- Language (LSP) specific configurations
require('lspconfig').sumneko_lua.setup {
  on_attach = function(client, bufnr)
    vim.bo.shiftwidth = 2
    vim.bo.tabstop = 2
    vim.bo.softtabstop = 2

    on_attach(client, bufnr)
  end,
  settings = {
    Lua = {
      diagnostics = {
        globals = { 'vim', 'use' }
      }
    }
  }
}
