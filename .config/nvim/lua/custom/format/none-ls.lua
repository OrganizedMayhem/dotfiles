return {
    "nvimtools/none-ls.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
        "nvim-lua/plenary.nvim",
        "mason-org/mason.nvim",
    },
    config = function()
        local none_ls = require("null-ls")

        -- Configure sources
        local sources = {
            -- Python
            none_ls.builtins.diagnostics.pyright,
            none_ls.builtins.formatting.black,
            none_ls.builtins.diagnostics.pylint,
            -- Go
            none_ls.builtins.formatting.goimports,
            none_ls.builtins.diagnostics.golangci_lint,
            none_ls.builtins.diagnostics.

            -- Markdown
            none_ls.builtins.formatting.prettier,
            none_ls.builtins.diagnostics.markdownlint,

            -- Spelling completion
            none_ls.builtins.completion.spell,
            
        }

        -- Create augroup once
        local augroup = vim.api.nvim_create_augroup("LspFormatting", { clear = true })

        -- Setup none-ls
        none_ls.setup({
            sources = sources,
            debug = false,
            update_in_insert = false,
            on_attach = function(client, bufnr)
                if client.supports_method("textDocument/formatting") then
                    vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
                    vim.api.nvim_create_autocmd("BufWritePre", {
                        group = augroup,
                        buffer = bufnr,
                        callback = function()
                            vim.lsp.buf.format({ bufnr = bufnr })
                        end,
                    })
                end
            end,
        })

        -- Keymaps for quick access
        vim.keymap.set("n", "<leader>lf", vim.lsp.buf.format, { noremap = true, silent = true, desc = "Format Buffer" })
        vim.keymap.set("n", "<leader>la", vim.lsp.buf.code_action, { noremap = true, silent = true, desc = "Code Action" })
        vim.keymap.set("n", "<leader>ld", vim.diagnostic.open_float, { noremap = true, silent = true, desc = "Show Diagnostics" })
        vim.keymap.set("n", "<leader>ln", vim.diagnostic.goto_next, { noremap = true, silent = true, desc = "Next Diagnostic" })
        vim.keymap.set("n", "<leader>lp", vim.diagnostic.goto_prev, { noremap = true, silent = true, desc = "Prev Diagnostic" })
    end,
}
