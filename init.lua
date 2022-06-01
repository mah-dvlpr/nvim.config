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
vim.cmd [[au ColorScheme * hi Normal ctermbg=none guibg=none]]
vim.cmd [[au ColorScheme * hi NonText ctermbg=none guibg=none]]
--vim.cmd[[colorscheme slate]]

-- ================================================================
-- Custom keymaps
global.map('', 'J', '8j', { noremap = true })
global.map('', 'K', '8k', { noremap = true })

-- ================================================================
-- Plugins
-- git clone --depth 1 https://github.com/wbthomason/packer.nvim "${HOME}/.local/share/nvim/site/pack/packer/start/packer.nvim"
vim.cmd [[packadd packer.nvim]]
require('packer').startup(function()
  use {
    'wbthomason/packer.nvim'
  }

  use {
    'williamboman/nvim-lsp-installer',
    requires = {
      'neovim/nvim-lspconfig',
    },
    config = function()
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
      require('plugins/lspconfig').config()
    end,
  }

  use {
    'nvim-treesitter/nvim-treesitter',
    config = function()
      require('nvim-treesitter.configs').setup {
        ensure_installed = { 'c', 'lua', 'rust' },
        sync_install = false,
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = false,
        },
      }
    end,
  }

  use {
    'nvim-telescope/telescope.nvim',
    requires = { 'nvim-lua/plenary.nvim' },
    config = function()
      local global = require('global')
      local opts = { noremap = true, silent = true }

      global.map('', '<C-f>', '<cmd>lua require("telescope.builtin").find_files()<cr>', opts)
      global.map('', '<C-g>', '<cmd>lua require("telescope.builtin").live_grep()<cr>', opts)
      global.map('', '<C-b>', '<cmd>lua require("telescope.builtin").buffers()<cr>', opts)

      if not os.execute('rg --version >/dev/null 2>&1') then
        error("Ripgrep package ('ripgrep') providing the command 'rg' is not installed. Live-grep will not work until this program is installed.")
      end
    end,
  }

  use {
    disable = true,
    'tjdevries/colorbuddy.vim',
    requires = { 'tjdevries/gruvbuddy.nvim' },
    config = function()
      require('colorbuddy').colorscheme('gruvbuddy')
    end
  }

  use {
    'romgrk/barbar.nvim',
    requires = { 'kyazdani42/nvim-web-devicons' },
    config = function()
      local global = require('global')
      local opts = { noremap = true, silent = true }

      global.map('n', '<A-,>', ':BufferPrevious<CR>', opts)
      global.map('n', '<A-.>', ':BufferNext<CR>', opts)
      -- Re-order to previous/next
      global.map('n', '<A-<>', ':BufferMovePrevious<CR>', opts)
      global.map('n', '<A->>', ' :BufferMoveNext<CR>', opts)
      -- Goto buffer in position...
      global.map('n', '<A-1>', ':BufferGoto 1<CR>', opts)
      global.map('n', '<A-2>', ':BufferGoto 2<CR>', opts)
      global.map('n', '<A-3>', ':BufferGoto 3<CR>', opts)
      global.map('n', '<A-4>', ':BufferGoto 4<CR>', opts)
      global.map('n', '<A-5>', ':BufferGoto 5<CR>', opts)
      global.map('n', '<A-6>', ':BufferGoto 6<CR>', opts)
      global.map('n', '<A-7>', ':BufferGoto 7<CR>', opts)
      global.map('n', '<A-8>', ':BufferGoto 8<CR>', opts)
      global.map('n', '<A-9>', ':BufferGoto 9<CR>', opts)
      global.map('n', '<A-0>', ':BufferLast<CR>', opts)
      -- Pin/unpin buffer
      global.map('n', '<A-p>', ':BufferPin<CR>', opts)
      -- Close buffer
      global.map('n', '<A-c>', ':BufferClose<CR>', opts)
      -- Wipeout buffer
      --                 :BufferWipeout<CR>
      -- Close commands
      --                 :BufferCloseAllButCurrent<CR>
      --                 :BufferCloseAllButPinned<CR>
      --                 :BufferCloseAllButCurrentOrPinned<CR>
      --                 :BufferCloseBuffersLeft<CR>
      --                 :BufferCloseBuffersRight<CR>
      -- Magic buffer-picking mode
      global.map('n', '<C-p>', ':BufferPick<CR>', opts)
      -- Sort automatically by...
      global.map('n', '<Space>bb', ':BufferOrderByBufferNumber<CR>', opts)
      global.map('n', '<Space>bd', ':BufferOrderByDirectory<CR>', opts)
      global.map('n', '<Space>bl', ':BufferOrderByLanguage<CR>', opts)
      global.map('n', '<Space>bw', ':BufferOrderByWindowNumber<CR>', opts)
    end
  }
end)

vim.g.bufferline = {
  icons = 'numbers',
  icon_separator_active = '▎',
  icon_separator_inactive = '▎',
  icon_close_tab = 'x',
  icon_close_tab_modified = '●',
  icon_pinned = '*',
}
