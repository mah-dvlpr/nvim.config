--------------------------------------
-- Definitions
-- Notes:
-- > nvim_set_keymap example is wrong in :h? Should not be string in options.
-- > nvim_set_options does not work for all options. For example 'wrap' false does not do anything. Not sure if it due to the global/local thing.
function toggle_cursor_centering()
    if vim.opt.scrolloff:get() == 999 then
        vim.opt.scrolloff = 5
    else
        vim.opt.scrolloff = 999
    end
end


----------------------------------------------------------------------------------------------------
-- Vim settings
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
vim.opt.scrolloff = 999                   -- Keep cursor centered by making the pre/post buffer padding very large


----------------------------------------------------------------------------------------------------
-- Keymaps
local nnoremap = function (lhs, rhs, options)
    return vim.api.nvim_set_keymap('n', lhs, rhs, options or { noremap = true })
end
vim.g.mapleader = 'ö'
-- Close window immediately
nnoremap('<Leader>q', ':q<CR>')
-- Toggle cursor centering
nnoremap('<Leader>C', ':lua toggle_cursor_centering()<CR>')
-- SPRINT!
nnoremap('J', '4j')
nnoremap('K', '4k')


----------------------------------------------------------------------------------------------------
-- Plugin installs followed by plugin settings
local util = require('packer.util')
require('packer').startup({
    function ()
        use { 'wbthomason/packer.nvim' }
        use { 'Mofiqul/vscode.nvim' }
        use { 'neovim/nvim-lspconfig' , requires = 'hrsh7th/nvim-compe' }
        use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }
        use { 'nvim-telescope/telescope.nvim', requires = { 'nvim-lua/popup.nvim', 'nvim-lua/plenary.nvim' } }
        use { 'tpope/vim-commentary' }
    end
    ,
    config = {
        compile_path = util.join_paths(vim.fn.stdpath('data'), 'plugin', 'packer_compiled.lua'),
    }
})


----------------------------------------------------------------------------------------------------
-- Mofiqul/vscode.nvim
vim.g.vscode_style = "light"
vim.cmd[[colorscheme vscode]]
vim.cmd[[highlight Whitespace ctermbg=NONE guibg=NONE ctermfg=Cyan guifg=#CCCCCC]]


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
  buf_set_keymap('n', 'H', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap('n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', '<space>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
  buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
  buf_set_keymap('n', '<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
  buf_set_keymap("n", "<space>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
end

-- Use a loop to conveniently call 'setup' on multiple servers and
-- map buffer local keybindings when the language server attaches
local servers = { "clangd" }
if next(servers) == nil then
    error("List of LSP servers is empty!")
end
for _, lsp in ipairs(servers) do
  nvim_lsp[lsp].setup {
    on_attach = on_attach,
    flags = {
      debounce_text_changes = 150,
    }
  }
end


----------------------------------------------------------------------------------------------------
-- nhrsh7th/nvim-compe
vim.o.completeopt = "menuone,noselect"
require'compe'.setup {
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

--This line is important for auto-import
--vim.api.nvim_set_keymap('i', '<cr>', 'compe#confirm("<cr>")', { expr = true })
--vim.api.nvim_set_keymap('i', '<c-space>', 'compe#complete()', { expr = true })


----------------------------------------------------------------------------------------------------
-- nvim-treesitter/nvim-treesitter
require'nvim-treesitter.configs'.setup {
  highlight = {
    enable = true,
    custom_captures = {
      -- Highlight the @foo.bar capture group with the "Identifier" highlight group.
      ["foo.bar"] = "Identifier",
    },
    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
  },
}


----------------------------------------------------------------------------------------------------
-- nvim-telescope/telescope.nvim
nnoremap("<Leader>ff", ":lua require('telescope.builtin').find_files()<Cr>")
nnoremap("<Leader>fg", ":lua require('telescope.builtin').live_grep()<Cr>")
nnoremap("<Leader>fb", ":lua require('telescope.builtin').buffers()<Cr>")
nnoremap("<Leader>fh", ":lua require('telescope.builtin').help_tags()<Cr>")
nnoremap("<Leader>fo", ":lua require('telescope.builtin').oldfiles()<Cr>")


----------------------------------------------------------------------------------------------------
-- mtpope/vim-commentary
-- FAQ
-- Q: "My favorite file type isn't supported!"
-- A: Relax! You just have to adjust 'commentstring': "autocmd FileType apache setlocal commentstring=#\ %s"
