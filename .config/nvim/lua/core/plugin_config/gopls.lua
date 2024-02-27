local lspconfig = require('lspconfig')

lspconfig.gopls.setup {
    cmd = {"gopls", "serve"},
    filetypes = {"go", "gomod"},
    root_dir = lspconfig.util.root_pattern("go.work", "go.mod", ".git"),
    settings = {
        gopls = {
            analyses = {
                unusedparams = true,
                shadow = true,
            },
            staticcheck = true,
            matcher = "Fuzzy",
            codelenses = {
                generate = true,
                gc_details = true,
                test = true,
                tidy = true,
            },
            usePlaceholders = true,
            completeUnimported = true,
            deepCompletion = true,
            gofumpt = false, -- set to true to enable gofumpt formatting
            hoverKind = "FullDocumentation",
            linksInHover = true,
            -- memoryMode = "DegradeClosed",
            symbolMatcher = "Fuzzy",
            symbolStyle = "Dynamic",
            verboseOutput = true,
            -- add other experimental features here
        },
    },
    on_attach = function(client, bufnr)
        -- Code to run when the language server attaches to a buffer
    end,
    flags = {
        debounce_text_changes = 150,
    },
}
