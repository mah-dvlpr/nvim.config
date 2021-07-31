call plug#begin(stdpath('data').'/plugins')
" Theming
Plug 'morhetz/gruvbox'

" Lsp stuff
Plug 'neovim/nvim-lspconfig'
Plug 'glepnir/lspsaga.nvim'

" Treesitter
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}  " We recommend updating the parsers on update

" Telescope
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-telescope/telescope.nvim'

" Misc
Plug 'hoob3rt/lualine.nvim'
call plug#end()


" ====================================================================================================
" Preamble
"" Create directory for saved session(s)
execute 'silent !mkdir -p '.stdpath('data').'/session'
"" Function to toggle centering
function Centered_toggle()
    if &scrolloff == 999
        set scrolloff=5
    else
        set scrolloff=999
    end
endfunction


" ====================================================================================================
" Custom settings
syntax enable                   " Enable syntax linting (not needed with an LSP?)
set termguicolors               " Use true colors, instead oluf just usual 256-bit colors.
set nowrap                      " Do not wrap lines, plain and simple.
set number relativenumber       " Absolute + Relative numbering (A.k.a. hybrid numbering).
set cursorline                  " Highlight current line.
set list                        " Render special characters such as whitespace and TAB's.
set listchars+=space:·          " Render whitespace as '·'.
set expandtab                   " Expand TABs into spaces when tabbing.
set shiftwidth=4                " Set amount of whitespace characters to insert/remove when tabbing/backspace.
set tabstop=4                   " Length of an actual TAB, i.e. not whitespace(s).
set softtabstop=4               " I have not idea what this does.
set backspace=start,indent,eol  " Allow performing backspace over (almost) everything in insert mode.
"set mouse=a                     " DON'T JUDGE ME! (allows mouse support in all modes).
set scrolloff=999               " Keep cursor centered by making the pre/post buffer padding very large


" ====================================================================================================
" Key mappings
let mapleader = 'ö'
"" Save session, save all files, and close all windows
nnoremap <Leader>q :execute 'mks! '.stdpath('data').'/session/tmp.vim'<CR> <Bar> :wqa<CR>
"" Load previously saved session
nnoremap <Leader>o :execute 'so '.stdpath('data').'/session/tmp.vim'<CR>
"" Toogle cursor centering
nnoremap <Leader>c :call Centered_toggle()<CR>


" ====================================================================================================
" Plugin config (Same order as they are installed)
"" Theming
colorscheme gruvbox
"" Lsp stuff
silent !which clangd &>/dev/null
if v:shell_error == 1
    echoerr "The language server for programming in C ('clangd') is not installed on your system!"
    echo "Please install 'clangd' using your systems package manager."
endif
"" Telescope
silent !which rg &>/dev/null
if v:shell_error == 1
    echoerr "Telescope's live-grep requires 'ripgrep' (command 'rg') to be installed!"
    echo "Please install 'ripgrep' using your systems package manager."
endif
nnoremap <Leader>ft <Cmd>Telescope<Cr>
nnoremap <Leader>ff <Cmd>Telescope find_files<Cr>
nnoremap <Leader>fg <Cmd>Telescope live_grep<Cr>
nnoremap <Leader>fb <Cmd>Telescope buffers<Cr>
nnoremap <Leader>fh <Cmd>Telescope help_tags<Cr>
nnoremap <Leader>fo <Cmd>Telescope oldfiles<Cr>


" ====================================================================================================
" Lua plugin config 'import' (These are located in ~/.config/nvim/lua)
lua << EOF
require('_lspconfig_config')
require('_lspsaga_config')
require('_treesitter_config')
require('_telescope_config')
require('_lualine_config')
EOF
