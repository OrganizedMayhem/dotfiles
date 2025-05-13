return { -- LSP Configuration
{
    "neovim/nvim-lspconfig",
    lazy = false,
    dependencies = {"mason-org/mason.nvim", "mason-org/mason-lspconfig.nvim"},
    config = function()
        local mason = require("mason")
        local mason_lspconfig = require("mason-lspconfig")
        local lspconfig = require("lspconfig")

        local install_servers = {"ruff", "pyright"}

        mason.setup({
            ensure_installed = install_servers,
            automatic_installation = true, -- Automatically install servers if not already installed
            automatic_setup = true -- Automatically setup servers if not already setup
        })
        mason_lspconfig.setup({
            ensure_installed = install_servers,
            automatic_enable = install_servers
        })

        -- Common on_attach function for key mappings
        local on_attach = function(_, bufnr)
            local opts = {
                noremap = true,
                silent = true,
                buffer = bufnr
            }
            local mappings = {
                ["<leader>cf"] = vim.lsp.buf.format,
                ["<leader>ca"] = vim.lsp.buf.code_action,
                ["gd"] = vim.lsp.buf.definition,
                ["K"] = vim.lsp.buf.hover,
                ["<leader>rn"] = vim.lsp.buf.rename
            }
            for k, v in pairs(mappings) do
                vim.keymap.set("n", k, v, opts)
            end
        end

        -- Setup LSP servers
        local servers = {
            ruff = {
                init_options = {
                    settings = {
                        -- General configuration
                        lineLength = 88,
                        exclude = {"build/", "dist/", "__about__.py"},
                        extendExclude = {},
                        select = {"E", "F", "W", "I"}, -- Default selected rules
                        ignore = {},
                        extendSelect = {}, -- Additional rules to enable
                        extendIgnore = {}, -- Additional rules to ignore
                        perFileIgnores = {
                            ["__init__.py"] = "F401"
                        },
                        targetVersion = "py315",
                        preview = false,

                        -- Lint configuration
                        lint = {
                            enable = true,
                            ignore = {},
                            select = {},
                            extendSelect = {},
                            unfixable = {},
                            fixable = {},
                            exemptModules = {},
                            strict = false,
                            allowPreview = true,
                            format = "grouped",
                            formatViolations = {}
                        },

                        -- Format configuration
                        format = {
                            enable = true,
                            indentStyle = "tab",
                            indentWidth = 4,
                            quoteStyle = "double",
                            lineEnding = "auto",
                            skipMagicTrailingComma = false,
                            preview = true
                        },

                        -- Plugin configurations
                        flake8_annotations = {
                            allow_star_arg_any = true,
                            mypy_init_return = false,
                            suppress_none_returning = false
                        },

                        flake8_bugbear = {
                            extend_immutable_calls = {}
                        },

                        flake8_tidy_imports = {
                            ban_relative_imports = "all",
                            banned_api = {
                                ["typing.TypedDict"] = {
                                    msg = "Use typing_extensions.TypedDict instead"
                                }
                            }
                        },

                        -- Experimental/Preview features
                        experimental = {
                            cache_size = 0,
                            watch = false
                        },

                        -- Path configuration
                        configuration = nil, -- Path to custom ruff.toml/pyproject.toml
                        path = {} -- Custom paths to ruff executables
                    }
                }
            },
            pyright = {
                settings = {
                    pyright = {
                        disableLanguageServices = false,
                        disableOrganizeImports = false,
                        autoImportCompletion = true,
                        useLibraryCodeForTypes = true,
                        typeCheckingMode = "strict", -- options: "off", "basic", "strict"
                        reportMissingTypeStubs = "warning", -- "none", "information", "warning", "error"
                        reportMissingImports = "warning",
                        reportImportCycles = "warning",
                        reportUnusedImport = "warning",
                        reportUnusedClass = "warning",
                        reportUnusedFunction = "warning",
                        reportUnusedVariable = "warning",
                        reportDuplicateImport = "warning",
                        reportWildcardImportFromLibrary = "warning",
                        reportOptionalSubscript = "warning",
                        reportOptionalMemberAccess = "warning",
                        reportOptionalCall = "warning",
                        reportOptionalIterable = "warning",
                        reportOptionalContextManager = "warning",
                        reportOptionalOperand = "warning",
                        reportGeneralTypeIssues = "warning",
                        reportIncompatibleMethodOverride = "warning",
                        reportIncompatibleVariableOverride = "warning",
                        reportOverlappingOverload = "warning",
                        reportMissingParameterType = "warning",
                        reportMissingTypeArgument = "warning",
                        reportUnknownArgumentType = "warning",
                        reportUnknownLambdaType = "warning",
                        reportUnknownParameterType = "warning",
                        reportUnknownVariableType = "warning",
                        reportUnboundVariable = "warning",
                        reportUnsupportedDunderAll = "warning",
                        reportPrivateImportUsage = "warning",
                        reportUnusedExpression = "warning",
                        reportMatchNotExhaustive = "warning",
                        reportShadowedImports = "warning",
                        reportUnnecessaryTypeIgnoreComment = "warning",
                        reportUnnecessaryCast = "warning",
                        reportUntypedFunctionDecorator = "warning",
                        reportUntypedClassDecorator = "warning",
                        reportUntypedBaseClass = "warning",
                        reportImplicitOverride = "warning",
                        reportMissingSuperCall = "warning",
                        reportMissingModuleSource = "warning"
                    },
                    python = {
                        pythonPath = "", -- Set your Python interpreter path if needed
                        analysis = {
                            autoSearchPaths = true,
                            diagnosticMode = "workspace", -- or "workspace"
                            useLibraryCodeForTypes = true,
                            typeCheckingMode = "strict", -- "off", "basic", "strict"
                            stubPath = "", -- Path to custom type stubs
                            extraPaths = {}, -- Additional import paths
                            exclude = {}, -- List of files/directories to exclude
                            ignore = {}, -- List of files/directories to ignore
                            logLevel = "Information", -- "Error", "Warning", "Information", "Trace"
                            autoImportCompletions = true,
                            diagnosticSeverityOverrides = {},
                            reportMissingImports = "warning",
                            reportMissingTypeStubs = "warning",
                            reportUnusedImport = "warning",
                            reportUnusedClass = "warning",
                            reportUnusedFunction = "warning",
                            reportUnusedVariable = "warning",
                            reportDuplicateImport = "warning",
                            reportWildcardImportFromLibrary = "warning",
                            reportOptionalSubscript = "warning",
                            reportOptionalMemberAccess = "warning",
                            reportOptionalCall = "warning",
                            reportOptionalIterable = "warning",
                            reportOptionalContextManager = "warning",
                            reportOptionalOperand = "warning",
                            reportGeneralTypeIssues = "warning",
                            reportIncompatibleMethodOverride = "warning",
                            reportIncompatibleVariableOverride = "warning",
                            reportOverlappingOverload = "warning",
                            reportMissingParameterType = "warning",
                            reportMissingTypeArgument = "warning",
                            reportUnknownArgumentType = "warning",
                            reportUnknownLambdaType = "warning",
                            reportUnknownParameterType = "warning",
                            reportUnknownVariableType = "warning",
                            reportUnboundVariable = "warning",
                            reportUnsupportedDunderAll = "warning",
                            reportPrivateImportUsage = "warning",
                            reportUnusedExpression = "warning",
                            reportMatchNotExhaustive = "warning",
                            reportShadowedImports = "warning",
                            reportUnnecessaryTypeIgnoreComment = "warning",
                            reportUnnecessaryCast = "warning",
                            reportUntypedFunctionDecorator = "warning",
                            reportUntypedClassDecorator = "warning",
                            reportUntypedBaseClass = "warning",
                            reportImplicitOverride = "warning",
                            reportMissingSuperCall = "warning",
                            reportMissingModuleSource = "warning"
                        }
                    }
                }
            }
        }

        for server, config in pairs(servers) do
            config.on_attach = on_attach
            lspconfig[server].setup(config)
        end
    end
}}
