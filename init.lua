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
vim.opt.softtabstop = 4                   -- I have not idea what this does.
vim.opt.backspace = 'start,indent,eol'    -- Allow performing backspace over (almost) everything in insert mode.
vim.opt.mouse = 'a'                       -- DON'T JUDGE ME! (allows mouse support in all modes).
vim.opt.scrolloff = 16                    -- Keep cursor centered by making the pre/post buffer padding very large


----------------------------------------------------------------------------------------------------
-- Global keymaps
vim.g.mapleader = 'ö'
vim.api.nvim_set_keymap('n', 'J', '4j', { noremap = true })
vim.api.nvim_set_keymap('n', 'K', '4k', { noremap = true })


----------------------------------------------------------------------------------------------------
-- Plugin installs followed by plugin settings
local util = require('packer.util')
require('packer').startup({
    function ()
        use { 'wbthomason/packer.nvim' }
        use { 'Mofiqul/vscode.nvim' }
        use { 'morhetz/gruvbox' }
        use { 'rakr/vim-one' }
        use { 'NLKNguyen/papercolor-theme' }
        use { 'neovim/nvim-lspconfig' , requires = { 'hrsh7th/nvim-compe' } }
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

    --Enable completion triggered by <c-x><c-o>
    buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

    -- Mappings.
    local opts = { noremap=true, silent=true }

    -- See `:help vim.lsp.*` for documentation on any of the below functions
    buf_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
    buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
    buf_set_keymap('n', 'gi', '<Cmd>lua vim.lsp.buf.implementaion()<CR>', opts)
    buf_set_keymap('n', '<C-k>', '<Cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
    buf_set_keymap('!', '<C-k>', '<Cmd>lua vim.lsp.buf.signature_help()<CR>', opts)

    vim.o.completeopt = "menuone,noselect"
    require('compe').setup {
        enabled = true;
        autocomplete = true;
        debug = false;
        min_length = 1;
        preselect = 'enable';
        throttle_time = 80;
        source_timeout = 200;
        resolve_timeout = 800;
        incomplete_delay = 400;
        max_abbr_width = 100;
        max_kind_width = 100;
        max_menu_width = 100;
        documentation = {
            border = { '', '' ,'', ' ', '', '', '', ' ' }, -- the border option is the same as `|help nvim_open_win|`
            winhighlight = "NormalFloat:CompeDocumentation,FloatBorder:CompeDocumentationBorder",
            max_width = 120,
            min_width = 60,
            max_height = math.floor(vim.o.lines * 0.3),
            min_height = 1,
        };
    
        source = {
            path = true;
            buffer = true;
            calc = true;
            nvim_lsp = true;
            nvim_lua = true;
            vsnip = true;
            ultisnips = true;
            luasnip = true;
        };
}

local t = function(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

local check_back_space = function()
    local col = vim.fn.col('.') - 1
    if col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') then
        return true
    else
        return false
    end
end

-- Use (s-)tab to:
--- move to prev/next item in completion menuone
--- jump to prev/next snippet's placeholder
_G.tab_complete = function()
  if vim.fn.pumvisible() == 1 then
    return t "<C-n>"
  elseif check_back_space() then
    return t "<Tab>"
  else
    return vim.fn['compe#complete']()
  end
end
_G.s_tab_complete = function()
  if vim.fn.pumvisible() == 1 then
    return t "<C-p>"
  else
    return t "<S-Tab>"
  end
end

vim.api.nvim_set_keymap("i", "<Tab>", "v:lua.tab_complete()", {expr = true})
vim.api.nvim_set_keymap("s", "<Tab>", "v:lua.tab_complete()", {expr = true})
vim.api.nvim_set_keymap("i", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})
vim.api.nvim_set_keymap("s", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})

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
if not os.execute('rg --version') then
    error("Ripgrep package ('ripgrep') providing the command 'rg' is not installed. Live-grep will not work.")
end
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
    component_separators = {'', ''},
    section_separators = {'', ''},
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
