----------------------------------------------------------------------------------------------------
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
vim.opt.relativenumber = true             -- Relative numberiing.
vim.opt.cursorline = true                 -- Highlight current line.
vim.opt.list = true                       -- Render special characters such as whitespace and TAB's.
vim.opt.listchars = 'space:·'             -- Render whitespace as '·'.
vim.opt.expandtab = true                  -- Expand TABs into spaces when tabbing.
vim.opt.shiftwidth = 4                    -- Set amount of whitespace characters to insert/remove when tabbing/backspace.
vim.opt.tabstop = 4                       -- Length of an actual TAB, i.e. not whitespace(s).
vim.opt.softtabstop = 4                   -- I have not idea what this does.
vim.opt.backspace = 'start,indent,eol'    -- Allow performing backspace over (almost) everything in insert mode.
vim.opt.mouse = 'a'                       -- DON'T JUDGE ME! (allows mouse support in all modes).
vim.opt.scrolloff = 999                   -- Keep cursor centered by making the pre/post buffer padding very large


----------------------------------------------------------------------------------------------------
-- Keymaps
local nnoremap = function (mode, lhs, rhs, options)
    return vim.api.nvim_set_keymap(mode, lhs, rhs, options or { noremap = true })
end
vim.g.mapleader = 'ö'
-- Close window immediately
nnoremap('n', '<Leader>q', ':q<CR>')
-- Toggle cursor centering
nnoremap('n', '<Leader>C', ':lua toggle_cursor_centering()<CR>')
-- SPRINT!
nnoremap('n', 'J', '4j')
nnoremap('n', 'K', '4k', { noremap = false })


----------------------------------------------------------------------------------------------------
-- Plugin (list)
vim.cmd([[
call plug#begin(stdpath('data').'/plugged')
" Theming
Plug 'morhetz/gruvbox'
call plug#end()
]])


----------------------------------------------------------------------------------------------------
-- Plugins (settings)
-------------------------------------------------- morhetz/gruvbox
vim.cmd('colo gruvbox')
-------------------------------------------------- 
