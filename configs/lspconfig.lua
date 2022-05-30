package.path = "../?.lua;" .. package.path
require('global')

local function config()
      local on_attach = function(client, bufnr)
      -- Generic mappings.
      map_buf(bufnr, 'n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>', lsp_on_attach_opts)
      map_buf(bufnr, 'n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', lsp_on_attach_opts)
      map_buf(bufnr, 'n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>', lsp_on_attach_opts)
      map_buf(bufnr, 'n', '<f2>', '<cmd>lua vim.lsp.buf.rename()<cr>', lsp_on_attach_opts)
      map_buf(bufnr, 'n', '<C-i>', '<cmd>lua vim.lsp.buf.code_action()<cr>', lsp_on_attach_opts)
      map_buf(bufnr, 'n', '<leader>f', '<cmd>lua vim.lsp.buf.formatting()<cr>', lsp_on_attach_opts)
    
      --  table.insert(lsp_on_attach_configs, function(client, bufnr)
      --    Map_buf(bufnr, 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>', lsp_on_attach_opts)
      --    Map_buf(bufnr, 'n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<cr>', lsp_on_attach_opts)
      --  end)
    
      -- Call registered handlers
      for callback in pairs(lsp_on_attach_configs) do
        callback(client, bufnr)
      end
    end


    
    -- Use a loop to conveniently call 'setup' on multiple servers and
    -- map buffer local keybindings when the language server attaches
    local servers = { 'sumneko_lua', 'rust_analyzer', 'clangd', 'dartls' }
    for _, lsp in pairs(servers) do
      require('lspconfig')[lsp].setup {
        on_attach = on_attach,
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

return { config = config }
