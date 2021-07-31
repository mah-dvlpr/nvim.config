call plug#begin(stdpath("data").'/plugins')
" Theming
Plug 'morhetz/gruvbox'

" Lsp stuff
Plug 'neovim/nvim-lspconfig'

" Misc
Plug 'hoob3rt/lualine.nvim'
call plug#end()


" Special
"" Create directory for sessions
:silent !mkdir -p "${HOME}/.local/share/nvim/sessions"


" Custom settings
set nowrap                      " Do not wrap lines, plain and simple.
set number relativenumber       " Absolute + Relative numbering (A.k.a. hybrid numbering).kkkj
set cursorline                  " Highlight current line.
set list                        " Render special characters such as whitespace and TAB's.
set listchars+=space:·          " Render whitespace as '·'.
set expandtab                   " Expand TABs into spaces when tabbing.
set shiftwidth=4                " Set amount of whitespace characters to insert/remove when tabbing/backspace.
set tabstop=4                   " Length of an actual TAB, i.e. not whitespace(s).
set softtabstop=4               " I have not idea what this does.
set backspace=start,indent,eol  " Allow performing backspace over (almost) everything in insert mode.
set mouse=a                     " DON'T JUDGE ME! (allos mouse support in all modes).
set termguicolors               " Use true colors, instead oluf just usual 256-bit colors.


" Key mappings
let mapleader = 'ö'
"" Close current window
nnoremap <Leader>w :q!<CR>
"" Save session, all files, and close all windows
nnoremap <Leader>q :mks! ~/.local/share/nvim/sessions/tmp.vim<CR> <Bar> :wqa<CR>
"" Load previously saved session
nnoremap <Leader>o :source ~/.local/share/nvim/sessions/tmp.vim<CR>
"" Misc
nnoremap ä :


" Plugin config (Same order as they are installed
colorscheme gruvbox
let g:gruvbox_transparent_bg = 1


" Lua plugin config 'import' (These are located in ~/.config/nvim/lua)
lua << EOF
require('lualine_config')
EOF
