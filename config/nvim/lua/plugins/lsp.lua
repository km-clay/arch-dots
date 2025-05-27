return {
  {
    "neovim/nvim-lspconfig",
		lazy = false,
    config = function()
      local lspconfig = require("lspconfig")

      local on_attach = function(_, bufnr)
        local nmap = function(keys, func, desc)
          vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
        end

        nmap("gd", vim.lsp.buf.definition, "Go to definition")
        nmap("K", vim.lsp.buf.hover, "Hover")
        nmap("<leader>rn", vim.lsp.buf.rename, "Rename")
        nmap("<leader>ca", vim.lsp.buf.code_action, "Code Action")
      end

      local capabilities = vim.lsp.protocol.make_client_capabilities()

      lspconfig.lua_ls.setup({
        on_attach = on_attach,
        capabilities = capabilities,
        settings = {
          Lua = {
            diagnostics = { globals = { "vim" } },
            workspace = { checkThirdParty = false },
          },
        },
      })

      lspconfig.pyright.setup({
        on_attach = on_attach,
        capabilities = capabilities,
      })

      lspconfig.ts_ls.setup({
        on_attach = on_attach,
        capabilities = capabilities,
      })

			lspconfig.bashls.setup({
				on_attach = on_attach,
				capabilities = capabilities,
			})

    end,
  }
}
