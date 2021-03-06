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
vim.opt.scrolloff = 16                    -- Keep cursor centered by making the pre/post buffer padding very large.
vim.opt.hidden = true                     -- Keep buffers open when switching between files.


----------------------------------------------------------------------------------------------------
-- Global user config
vim.g.mapleader = 'ö'
vim.api.nvim_set_keymap('', '<C-w><C-b>', '<Cmd>bp<Bar>bw #<Cr>', { noremap = true, silent = true })

-- "Sprint mode"
vim.api.nvim_set_keymap('', 'J', '8j', { noremap = true })
vim.api.nvim_set_keymap('', 'K', '8k', { noremap = true })

-- Save/Load sessions
vim.cmd[[au VimLeave * mks! ~/.local/share/nvim/Session.vim]]
-- vim.cmd[[au VimEnter * so Session.vim]]


----------------------------------------------------------------------------------------------------
-- Plugin(s) (followed by plugin settings)
local util = require('packer.util')
require('packer').startup({
    function ()
        -- Essential
        use { 'wbthomason/packer.nvim' }
        use { 'neovim/nvim-lspconfig' }
        use { 'nvim-treesitter/nvim-treesitter' , run = function() vim.cmd[[TSUpdate]]; end }
        use { 'nvim-telescope/telescope.nvim', requires = { 'nvim-lua/popup.nvim', 'nvim-lua/plenary.nvim' } }

        -- Utilities
        use { 'ray-x/lsp_signature.nvim' }
        use { 'hrsh7th/nvim-cmp', requires = { 'hrsh7th/cmp-nvim-lsp' } }
        use { 'L3MON4D3/LuaSnip', requires = { 'saadparwaiz1/cmp_luasnip' } }
        use { 'tpope/vim-commentary' }
        use { 'akinsho/toggleterm.nvim' }

        -- Look and Feel
        use { 'folke/lsp-colors.nvim' }
        use { 'NLKNguyen/papercolor-theme' }
        use { 'tomasiser/vim-code-dark' }
        use { 'morhetz/gruvbox' }
        use { 'hoob3rt/lualine.nvim' }
        use { 'dstein64/nvim-scrollview' }
    end
    ,
    config = {
        compile_path = util.join_paths(vim.fn.stdpath('data'), 'plugin', 'packer_compiled.lua'),
    }
})
-- Check if plugins have been installed before continuing, otherwise exit (by checking that at least one of them is installed)
if not pcall(require, 'lspconfig') then
    return
end


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
    buf_set_keymap('n', '<C-k>', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
    buf_set_keymap('i', '<C-k>', '<Cmd>lua vim.lsp.buf.signature_help()<CR>', opts)

    -- LSP-dependent extensions
    vim.o.completeopt = "menuone,noselect"
    local luasnip = require('luasnip')
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

    require('lsp_signature').on_attach({
        bind = true, -- This is mandatory, otherwise border config won't get registered.
        handler_opts = {
            border = 'single'
        },
        hint_enable = false,
        hi_parameter = 'IncSearch',
    }, bufnr)
end

-- Use a loop to conveniently call 'setup' on multiple servers and
-- map buffer local keybindings when the language server attaches
-- Full list of supported LSP's can be found at: https://github.com/neovim/nvim-lspconfig/blob/master/CONFIG.md
local servers = { 'clangd', 'rust_analyzer', 'pyright' }
for _, lsp in ipairs(servers) do
    nvim_lsp[lsp].setup {
      on_attach = on_attach,
      flags = {
        debounce_text_changes = 150,
      },
    capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
    }
end


----------------------------------------------------------------------------------------------------
-- nvim-treesitter/nvim-treesitter
if not os.execute('c++ --version >/dev/null 2>&1') then
    error("C++ compiler package ('gcc-c++') is not installed. Installing languages in/with treesitter will not work (fail to compile).")
end
require('nvim-treesitter.configs').setup({
    ensure_installed = { 'bash', 'c', 'cmake', 'comment', 'cpp', 'dockerfile', 'java', 'javascript', 'json', 'latex', 'lua', 'php', 'python', 'regex', 'rust', 'typescript', 'yaml' },
    highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
    },
})


----------------------------------------------------------------------------------------------------
-- nvim-telescope/telescope.nvim
if not os.execute('rg --version >/dev/null 2>&1') then
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
vim.api.nvim_set_keymap('n', '<Leader>e', ":lua require('telescope.builtin').file_browser()<Cr>", { noremap = true })
vim.api.nvim_set_keymap('n', '<Leader>b', ":lua require('telescope.builtin').buffers()<Cr>", { noremap = true })
vim.api.nvim_set_keymap('n', '<Leader>o', ":lua require('telescope.builtin').oldfiles()<Cr>", { noremap = true })
vim.api.nvim_set_keymap('n', '<Leader>h', ":lua require('telescope.builtin').help_tags()<Cr>", { noremap = true })
vim.api.nvim_set_keymap('n', '<Leader>r', ":lua require('telescope.builtin').lsp_references()<Cr>", { noremap = true })
vim.api.nvim_set_keymap('n', '<Leader>d', ":lua require('telescope.builtin').lsp_document_diagnostics()<Cr>", { noremap = true })
vim.api.nvim_set_keymap('n', '<Leader>a', ":lua require('telescope.builtin').lsp_code_actions()<Cr>", { noremap = true })


----------------------------------------------------------------------------------------------------
-- akinsho/toggleterm.nvim
require("toggleterm").setup({
    -- size can be a number or function which is passed the current terminal
    size = 20,
    open_mapping = [[<c-\>]],
    hide_numbers = true, -- hide the number column in toggleterm buffers
    shade_filetypes = {},
    shade_terminals = true,
    shading_factor = 1, -- the degree by which to darken to terminal colour, default: 1 for dark backgrounds, 3 for light
    start_in_insert = true,
    insert_mappings = true, -- whether or not the open mapping applies in insert mode
    persist_size = true,
    direction = 'float',
    close_on_exit = true, -- close the terminal window when the process exits
    shell = vim.o.shell, -- change the default shell
    -- This field is only relevant if direction is set to 'float'
    float_opts = {
        border = 'single',
        width = 128,
        height = 32,
        winblend = 10,
        highlights = {
            border = "Normal",
            background = "Normal",
        }
    }
})
vim.api.nvim_set_keymap('', '<C-t>', '<Cmd>ToggleTerm<Cr>', { noremap = true })
vim.api.nvim_set_keymap('t', '<C-t>', '<C-\\><C-N><Bar><Cmd>ToggleTerm<Cr>', { noremap = true })
vim.api.nvim_set_keymap('t', '<Esc>', '<C-\\><C-N>', { noremap = true })


----------------------------------------------------------------------------------------------------
-- Theme stuff
require("lsp-colors").setup({
  Error = "#db4b4b",
  Warning = "#e0af68",
  Information = "#0db9d7",
  Hint = "#10B981"
})
vim.cmd[[colorscheme PaperColor]]
vim.cmd[[set background=dark]]
vim.cmd[[let g:PaperColor_Theme_Options={'theme':{'default':{'allow_bold':0, 'transparent_background': 1}}}]]
vim.cmd[[au ColorScheme PaperColor hi Normal ctermbg=234 guibg=#1C1C1C]]


----------------------------------------------------------------------------------------------------
-- hoob3rt/lualine.nvim
require('lualine').setup({
  options = {
    icons_enabled = false,
    theme = 'nord',
    component_separators = {'|', '|'},
    section_separators = {'', ''},
  },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {'encoding','fileformat','filetype'},
    lualine_c = {{
        'filename',
        file_status = true, -- displays file status (readonly status, modified status)
        path = 2 -- 0 = just filename, 1 = relative path, 2 = absolute path
    }},
    lualine_x = {{
        'diagnostics',
        sources = {'nvim_lsp'},
        sections = {'error', 'warn', 'info', 'hint'},
        color_error = '#FF4444',
        color_warn = '#FF8000',
        color_info = '#FFFF00',
        color_hint = '#FFFFFF',
        symbols = {error = 'E', warn = 'W', info = 'I', hint = 'H'}
    }},
    lualine_y = {{
        'diff',
        colored = true,
        color_added = '#AAFF44',
        color_modified = '#44AAFF',
        color_removed = '#FF4444',
        symbols = { added = '+', modified = '~', removed = '-' }
    }},
    lualine_z = {'branch'}
  },
  inactive_sections = {
    lualine_c = {'filename'},
    lualine_x = {'location'},
  },
})


----------------------------------------------------------------------------------------------------
-- Custom "Plugins" (Can be seen as superfluous junk, but it is a bit of fun)
-- Transparent background stuff (ONLY WORKS WITH GNOME TERMINAL!)
if not os.execute('mpv --version >/dev/null 2>&1') then
    error("Mpv ('mpv') is not installed. Live wallpaper(s) will not be available.")
end
if not os.execute('wmctrl --version >/dev/null 2>&1') then
    error("Wmctrl ('wmctrl') is not installed.")
end
local transp_bg_wallpapers = {
    'https://www.youtube.com/watch?v=lH6qlF_iegU',
    'https://www.youtube.com/watch?v=G2CHyuF74R0',
    'https://www.youtube.com/watch?v=J2qDRJdTGow',
}
local transp_bg_wallpapers_index = 1
transp_bg_wallpapers_index_max = 0
for _ in pairs(transp_bg_wallpapers) do
    transp_bg_wallpapers_index_max = transp_bg_wallpapers_index_max + 1
end
function transp_bg (arg)
    vim.cmd[[hi Normal ctermbg=None guibg=None]]

    local timeout = 5
    local addr = '/org/gnome/terminal/legacy/profiles:/:b1dcc9dd-5262-4d8d-a863-c897e6d979b9/background-transparency-percent'

    if arg == '+' or arg == '-' then
        os.execute('dconf write ' .. addr .. ' $(($(dconf read ' .. addr .. ') ' .. arg .. '5))')
    elseif arg == 'reset' then
        os.execute('dconf write ' .. addr .. ' ' .. 20)
        os.execute('timeout ' .. timeout .. ' bash -c "while pkill mpv >/dev/null 2>&1; do :; done"')
        vim.cmd[[execute 'colo' g:colors_name]]
    else
        os.execute('dconf write ' .. addr .. ' ' .. 20)
        os.execute('timeout ' .. timeout .. ' bash -c "while pkill mpv >/dev/null 2>&1; do :; done"')
        os.execute('mpv "' .. transp_bg_wallpapers[transp_bg_wallpapers_index] .. '" --no-audio --loop -fs >/dev/null 2>&1 & timeout ' .. timeout .. ' bash -c "while ! wmctrl -l 2>/dev/null | grep mpv >/dev/null 2>&1; do :; done"')
        os.execute('wmctrl -a ${PWD##*/} >/dev/null 2>&1')
        transp_bg_wallpapers_index = transp_bg_wallpapers_index % transp_bg_wallpapers_index_max + 1
    end
end
vim.cmd[[au VimLeave * lua os.execute('while pkill mpv >/dev/null 2>&1; do :; done')]]
vim.api.nvim_set_keymap('', '<C-Down>', "<Cmd>lua transp_bg('-')<Cr>", { noremap = true })
vim.api.nvim_set_keymap('', '<C-Up>', "<Cmd>lua transp_bg('+')<Cr>", { noremap = true })
vim.api.nvim_set_keymap('', '<C-Left>', "<Cmd>lua transp_bg('reset')<Cr>", { noremap = true })
vim.api.nvim_set_keymap('', '<C-Right>', "<Cmd>lua transp_bg()<Cr>", { noremap = true })
