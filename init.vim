""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Preamble
"" Create directory for saved session(s)
execute 'silent !mkdir -p '.stdpath('data').'/session'
"" Function to toggle centering
function Toggle_centered_cursor()
    if &scrolloff == 999
        set scrolloff=5
    else
        set scrolloff=999
    end
endfunction


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Plugins (Each 'Plug' with a header have their settings configured further down).
call plug#begin(stdpath('data').'/plugins')
" gruvbox
Plug 'morhetz/gruvbox'

" nvim-lspconfig
Plug 'neovim/nvim-lspconfig'

" lspsaga
Plug 'glepnir/lspsaga.nvim'

" nvim-treesitter
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}  " We recommend updating the parsers on update

" telescope
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-telescope/telescope.nvim'

" lualine
Plug 'hoob3rt/lualine.nvim'
call plug#end()


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
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


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Key mappings
let mapleader = 'ö'
"" Close window
nnoremap <Leader>q :q<CR>
"" Save session, save all files, and close all windows
nnoremap <Leader>Q :execute 'mks! '.stdpath('data').'/session/tmp.vim'<CR> <Bar> :wqa<CR>
"" Load previously saved session
nnoremap <Leader>O :execute 'so '.stdpath('data').'/session/tmp.vim'<CR>
"" Toogle cursor centering
nnoremap <Leader>C :call Toggle_centered_cursor()<CR>


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Plugin configurations
"""""""""""""""""""""""""""""""""""""""""""""""""" Plug 'morhetz/gruvbox'
colorscheme gruvbox
" Make background transparent
let g:gruvbox_transparent_bg=1
highlight Normal     ctermbg=NONE guibg=NONE
highlight LineNr     ctermbg=NONE guibg=NONE
highlight SignColumn ctermbg=NONE guibg=NONE

"""""""""""""""""""""""""""""""""""""""""""""""""" Plug 'neovim/nvim-lspconfig'
"""""""""""""""""""""""""""""""""""""""""""""""""" Plug 'glepnir/lspsaga.nvim'
"""""""""""""""""""""""""""""""""""""""""""""""""" Plug 'nvim-treesitter/nvim-treesitter'
"""""""""""""""""""""""""""""""""""""""""""""""""" Plug 'nvim-telescope/telescope.nvim'
"""""""""""""""""""""""""""""""""""""""""""""""""" Plug 'hoob3rt/lualine.nvim'
