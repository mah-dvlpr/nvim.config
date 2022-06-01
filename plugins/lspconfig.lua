local global = require('global')
local lspconfig = {}

function lspconfig.config()
  local on_attach = function(client, bufnr)
    -- Enable completion triggered by <c-x><c-o>
    vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

    -- Generic mappings.
    global.map_buf(bufnr, 'n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>', global.lsp_on_attach_opts)
    global.map_buf(bufnr, 'n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', global.lsp_on_attach_opts)
    global.map_buf(bufnr, 'n', '<C-LeftMouse>', '<LeftMouse><cmd>lua vim.lsp.buf.definition()<cr>', global.lsp_on_attach_opts)
    global.map_buf(bufnr, 'n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>', global.lsp_on_attach_opts)
    global.map_buf(bufnr, 'n', '<f2>', '<cmd>lua vim.lsp.buf.rename()<cr>', global.lsp_on_attach_opts)
    global.map_buf(bufnr, 'n', '<leader>a', '<cmd>lua vim.lsp.buf.code_action()<cr>', global.lsp_on_attach_opts)
    global.map_buf(bufnr, 'n', '<leader>q', '<cmd>lua vim.lsp.buf.formatting()<cr>', global.lsp_on_attach_opts)

    global.map_buf(bufnr, 'n', '<C-h>', '<cmd>lua vim.lsp.buf.hover()<cr>', global.lsp_on_attach_opts)
    global.map_buf(bufnr, 'n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<cr>', global.lsp_on_attach_opts)

    -- Call registered handlers
    for callback in pairs(global.lsp_on_attach_configs) do
      callback(client, bufnr)
    end
  end

  -- Use a loop to conveniently call 'setup' on multiple servers and
  -- map buffer local keybindings when the language server attaches
  local servers = { 'sumneko_lua', 'rust_analyzer', 'clangd', 'dartls' }
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)
  for _, lsp in pairs(servers) do
    require('lspconfig')[lsp].setup {
      on_attach = on_attach,
      capabilities = capabilities,
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
end

return lspconfig
