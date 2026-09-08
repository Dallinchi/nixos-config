return {
    "nvim-lspconfig",
    lazy = false,

    before = function()
        local on_attach = function(client, bufnr)
            local opts = { noremap = true, silent = true, buffer = bufnr }

            vim.keymap.set('v', 'F', vim.lsp.buf.format, opts)
            vim.keymap.set('n', '<leader>F', vim.lsp.buf.format, opts)
            vim.keymap.set('n', '<leader>k', vim.diagnostic.open_float, opts)
            vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)
            vim.keymap.set('n', 'gD', vim.lsp.buf.type_definition, opts)
            -- bufmap(bufnr, 'n', 'gE', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
            -- bufmap(bufnr, 'n', 'ge', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
        end

        local capabilities = require("blink.cmp").get_lsp_capabilities()
        -- Python LSP
        vim.lsp.config("basedpyright", {
          on_attach = on_attach,
          capabilities = capabilities,
        })

        vim.lsp.enable("basedpyright")

        -- C++ LSP
        vim.lsp.config("clangd", {
          on_attach = on_attach,
          capabilities = capabilities,
        })

        vim.lsp.enable("clangd")

        -- Lua LSP
        vim.lsp.config("lua_ls", {
            settings = {
                Lua = {
                    diagnostics = { globals = { "vim" } },
                    telemetry = {

                        enable = false
                    },
                    workspace = {
                        checkThirdParty = "Apply"
                    }
                },
            },
        })

        vim.lsp.config("lua_ls", { on_attach = on_attach, capabilities = capabilities })
        vim.lsp.enable("lua_ls")

        vim.lsp.config("nixd", {
            on_attach = on_attach,
            capabilities = capabilities,
            cmd = { "nixd" },
            settings = {
                nixd = {
                    nixpkgs = {
                        expr = "import <nixpkgs> { }",
                    },
                    formatting = {
                        command = { "alejandra" },
                    },
                },
            },
        })
        vim.lsp.enable("nixd")

        vim.lsp.config("gleam", { on_attach = on_attach, capabilities = capabilities })
        vim.lsp.enable("gleam")

    end,
}
