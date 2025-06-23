return {
        cmd = { "terraform-ls", "serve" },                                  -- Command to start the language server
        filetypes = { "terraform", "tf", "terraform-vars", "hcl" },         -- File types that this server will handle
        root_markers = { ".terraform", "main.tf", ".git", "terraform.tf" }, -- Markers to identify the root of the project
        settings = {                                                        -- Settings for the language server
                -- Indexing settings
                indexing = {
                        ignoreDirectoryNames = {
                                ".terraform",
                                ".git",
                                "node_modules",
                                ".vscode",
                                ".idea",
                                ".vscode-test"
                        },                -- Directories to ignore during indexing
                        ignorePaths = {}, -- Specific paths to ignore (supports relative paths and ~)
                },
                -- Warning settings
                ignoreDirectoryNames = {
                        ".terraform",
                        ".git",
                        "node_modules",
                        ".vscode",
                        ".idea",
                        ".vscode-test"
                },                              -- Always ignored directories
                ignoreSingleFileWarning = true, -- Suppress warning about opening single files
                -- Experimental features
                experimentalFeatures = {
                        validateOnSave = true,        -- Run terraform validate on save
                        prefillRequiredFields = true, -- Pre-fill required fields in completion
                },

                -- Validation settings
                validation = {
                        enableEnhancedValidation = true, -- Enable enhanced validation features
                },

                -- Code lens settings
                codeLens = {
                        referenceCount = true, -- Show reference counts above blocks
                },

                -- Completion settings
                completion = {
                        prefillRequiredFields = true, -- Pre-fill required fields during completion
                },

                -- Semantic tokens
                semanticTokens = true, -- Enable semantic token highlighting
                -- Documentation links
                documentLinks = true,  -- Enable documentation links for modules

                -- Formatting settings
                formatting = {
                        command = "terraform", -- Command used for formatting
                        args = { "fmt", "-" }, -- Arguments for formatting command
                },
        },
}
