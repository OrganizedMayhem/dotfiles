local cmp = require("cmp")

require("luasnip.loaders.from_vscode").lazy_load()

cmp.setup({
    mapping = cmp.mapping.preset.insert({
        ['<C-b>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-o>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.abort(),
        ['<CR>'] = cmp.mapping.confirm({
            select = true
        })
    }),
    snippet = {
        expand = function(args)
            require('luasnip').lsp_expand(args.body)
        end
    },
    sources = cmp.config.sources({{
        name = 'nvim_lsp'
    }, {
        name = 'luasnip'
    }}, {{
        name = 'buffer'
    }})
})
-- Set up lspconfig
local lspconfig = require 'lspconfig'

-- Configure Pyright
lspconfig.pyright.setup {
    on_attach = function(client, bufnr)
        -- Enable completion triggered by <c-x><c-o>
        vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

        -- Mappings.
        -- See `:help vim.lsp.*` for documentation on any of the below functions
        local opts = {
            noremap = true,
            silent = true
        }

        vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
        vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
        vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
        vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gi', '<Cmd>lua vim.lsp.buf.implementation()<CR>', opts)
        vim.api.nvim_buf_set_keymap(bufnr, 'n', '<C-k>', '<Cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
        vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>wa', '<Cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
        vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>wr', '<Cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
        vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>wl',
            '<Cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
        vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>D', '<Cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
        vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>rn', '<Cmd>lua vim.lsp.buf.rename()<CR>', opts)
        vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gr', '<Cmd>lua vim.lsp.buf.references()<CR>', opts)
        vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>e', '<Cmd>lua vim.diagnostic.open_float()<CR>', opts)
        vim.api.nvim_buf_set_keymap(bufnr, 'n', '[d', '<Cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
        vim.api.nvim_buf_set_keymap(bufnr, 'n', ']d', '<Cmd>lua vim.diagnostic.goto_next()<CR>', opts)
        vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>q', '<Cmd>lua vim.diagnostic.setloclist()<CR>', opts)
        vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>f', '<Cmd>lua vim.lsp.buf.formatting()<CR>', opts)
    end,

    flags = {
        debounce_text_changes = 150
    }
}
