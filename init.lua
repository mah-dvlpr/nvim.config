----------------------------------------------------------------------------------------------------
-- Vim settings/options
vim.opt.clipboard = 'unnamedplus'         -- Enable system clipboard
vim.opt.syntax = 'on'                     -- Enable syntax linting (not needed with an LSP?)
vim.opt.termguicolors = true              -- Use true colors, instead oluf just usual 256-bit colors.
vim.opt.wrap = false                      -- Do not wrap lines, plain and simple.
vim.opt.number = true                     -- Absolute numbering.
vim.opt.cursorline = true                 -- Highlight current line.
vim.opt.list = true                       -- Render special characters such as whitespace and TAB's.
vim.opt.listchars = "tab:> ,space:·"      -- Render whitespace as '·'.
vim.opt.expandtab = true                  -- Expand TABs into spaces when tabbing.
vim.opt.shiftwidth = 4                    -- Set amount of whitespace characters to insert/remove when tabbing/backspace.
vim.opt.tabstop = 4                       -- Length of an actual TAB, i.e. not whitespace(s).
vim.opt.softtabstop = 4                   -- I have no idea what this does.
vim.opt.backspace = 'start,indent,eol'    -- Allow performing backspace over (almost) everything in insert mode.
vim.opt.mouse = 'a'                       -- DON'T JUDGE ME! (allows mouse support in all modes).
vim.opt.scrolloff = 16                    -- Keep cursor centered by making the pre/post buffer padding very large


----------------------------------------------------------------------------------------------------
-- Global keymaps
vim.g.mapleader = 'ö'
vim.api.nvim_set_keymap('n', 'J', '8j', { noremap = true })
vim.api.nvim_set_keymap('n', 'K', '8k', { noremap = true })


----------------------------------------------------------------------------------------------------
-- Plugin(s) (followed by plugin settings)
local util = require('packer.util')
require('packer').startup({
    function ()
        use { 'wbthomason/packer.nvim' }
        use { 'Mofiqul/vscode.nvim' }
        use { 'morhetz/gruvbox' }
        use { 'rakr/vim-one' }
        use { 'NLKNguyen/papercolor-theme' }
        use { 'neovim/nvim-lspconfig' , requires = { 'hrsh7th/nvim-cmp', 'hrsh7th/cmp-nvim-lsp' } }
        use { 'nvim-treesitter/nvim-treesitter' , run = function() vim.cmd[[TSUpdate]]; end }
        use { 'nvim-telescope/telescope.nvim', requires = { 'nvim-lua/popup.nvim', 'nvim-lua/plenary.nvim' } }
        use { 'tpope/vim-commentary' }
        use { 'hoob3rt/lualine.nvim' }
    end
    ,
    config = {
        compile_path = util.join_paths(vim.fn.stdpath('data'), 'plugin', 'packer_compiled.lua'),
    }
})


----------------------------------------------------------------------------------------------------
-- Themes
--vim.g.vscode_style = "light"
--vim.cmd[[colorscheme vscode]]
--vim.cmd[[au ColorScheme * highlight Whitespace ctermbg=NONE guibg=NONE ctermfg=Cyan guifg=#444444]]
--vim.cmd[[au ColorScheme * highlight Normal ctermbg=NONE guibg=NONE]]
--vim.cmd[[colorscheme gruvbox]]
--vim.cmd[[colorscheme one]]
--vim.cmd[[set background=light]]
vim.cmd[[colorscheme PaperColor]]
vim.cmd[[set background=light]]
vim.cmd[[let g:PaperColor_Theme_Options={'theme':{'default':{'allow_bold':0}}}]]


----------------------------------------------------------------------------------------------------
-- neovim/nvim-lspconfig
local nvim_lsp = require('lspconfig')

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
    local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
    local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

    --Enable completion triggered by <c-x><c-o> (IN INSERT MODE!)
    buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

    -- Mappings. (See `:help vim.lsp.*` for documentation on any of the below functions)
    local opts = { noremap=true, silent=true }
    buf_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
    buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
    buf_set_keymap('n', 'gi', '<Cmd>lua vim.lsp.buf.implementation()<CR>', opts)
    buf_set_keymap('n', '<C-k>', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
    buf_set_keymap('i', '<C-k>', '<Cmd>lua vim.lsp.buf.signature_help()<CR>', opts)

    -- LSP-dependent extensions
    vim.o.completeopt = "menuone,noselect"
    local cmp = require('cmp')
    cmp.setup {
        snippet = {
            expand = function(args)
                require('luasnip').lsp_expand(args.body)
            end,
        },
        mapping = {
          ['<C-p>'] = cmp.mapping.select_prev_item(),
          ['<C-n>'] = cmp.mapping.select_next_item(),
          ['<C-u>'] = cmp.mapping.scroll_docs(-4),
          ['<C-d>'] = cmp.mapping.scroll_docs(4),
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<C-e>'] = cmp.mapping.close(),
          ['<CR>'] = cmp.mapping.confirm {
              behavior = cmp.ConfirmBehavior.Replace,
              select = true,
          },
          ['<Tab>'] = function(fallback)
              if vim.fn.pumvisible() == 1 then
                  vim.fn.feedkeys(vim.api.nvim_replace_termcodes('<C-n>', true, true, true), 'n')
              elseif luasnip.expand_or_jumpable() then
                  vim.fn.feedkeys(vim.api.nvim_replace_termcodes('<Plug>luasnip-expand-or-jump', true, true, true), '')
              else
                  fallback()
              end
          end,
          ['<S-Tab>'] = function(fallback)
              if vim.fn.pumvisible() == 1 then
                  vim.fn.feedkeys(vim.api.nvim_replace_termcodes('<C-p>', true, true, true), 'n')
              elseif luasnip.jumpable(-1) then
                  vim.fn.feedkeys(vim.api.nvim_replace_termcodes('<Plug>luasnip-jump-prev', true, true, true), '')
              else
                  fallback()
              end
          end,
        },
        sources = {
            { name = 'nvim_lsp' },
            { name = 'luasnip' },
        },
    }
end

-- Use a loop to conveniently call 'setup' on multiple servers and
-- map buffer local keybindings when the language server attaches
local servers = { 'clangd', 'rust_analyzer' }
for _, lsp in ipairs(servers) do
    nvim_lsp[lsp].setup {
      on_attach = on_attach,
      flags = {
        debounce_text_changes = 150,
      }
    }
end


----------------------------------------------------------------------------------------------------
-- nvim-treesitter/nvim-treesitter
if not os.execute('c++ --version') then
    error("C++ compiler package ('gcc-c++') is not installed. Installing languages in/with treesitter will not work (fail to compile).")
end
require('nvim-treesitter.configs').setup({
    ensure_installed = { 'bash', 'c', 'cmake', 'comment', 'cpp', 'dockerfile', 'java', 'javascript', 'json', 'latex', 'lua', 'php', 'python', 'regex', 'rust', 'typescript', 'yaml' },
    highlight = {
        enable = true,
        -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
        -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
        -- Using this option may slow down your editor, and you may see some duplicate highlights.
        -- Instead of true it can also be a list of languages
        additional_vim_regex_highlighting = false,
    },
})


----------------------------------------------------------------------------------------------------
-- nvim-telescope/telescope.nvim
if not os.execute('rg --version') then
    error("Ripgrep package ('ripgrep') providing the command 'rg' is not installed. Live-grep will not work.")
end
local actions = require('telescope.actions')
require('telescope').setup{
    defaults = {
        layout_strategy = 'vertical',
        mappings = {
          i = {
            ["<esc>"] = actions.close
          },
        },
    }
}
vim.api.nvim_set_keymap('n', '<Leader>f', ":lua require('telescope.builtin').find_files()<Cr>", { noremap = true })
vim.api.nvim_set_keymap('n', '<Leader>g', ":lua require('telescope.builtin').live_grep()<Cr>", { noremap = true })
vim.api.nvim_set_keymap('n', '<Leader>b', ":lua require('telescope.builtin').buffers()<Cr>", { noremap = true })
vim.api.nvim_set_keymap('n', '<Leader>o', ":lua require('telescope.builtin').oldfiles()<Cr>", { noremap = true })
vim.api.nvim_set_keymap('n', '<Leader>h', ":lua require('telescope.builtin').help_tags()<Cr>", { noremap = true })
vim.api.nvim_set_keymap('n', '<Leader>m', ":lua require('telescope.builtin').man_pages()<Cr>", { noremap = true })
vim.api.nvim_set_keymap('n', '<Leader>r', ":lua require('telescope.builtin').lsp_references()<Cr>", { noremap = true })
vim.api.nvim_set_keymap('n', '<Leader>d', ":lua require('telescope.builtin').lsp_document_diagnostics()<Cr>", { noremap = true })
vim.api.nvim_set_keymap('n', '<Leader>a', ":lua require('telescope.builtin').lsp_code_actions(require()<Cr>", { noremap = true })


----------------------------------------------------------------------------------------------------
-- hoob3rt/lualine.nvim
require('lualine').setup({
  options = {
    icons_enabled = false,
    theme = 'vscode',
    component_separators = {'|', '|'},
    section_separators = {' ', ' '},
    disabled_filetypes = {}
  },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {''},
    lualine_c = {'encoding','fileformat','filetype','filename'},
    lualine_x = {'location','progress','diff'},
    lualine_y = {''},
    lualine_z = {'branch'}
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {'filename'},
    lualine_x = {'location'},
    lualine_y = {},
    lualine_z = {}
  },
  tabline = {},
  extensions = {}
})
