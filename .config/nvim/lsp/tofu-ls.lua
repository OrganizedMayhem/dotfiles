return {
	cmd = { "tofu-ls", "serve" }, -- Command to start the tofu language server
	filetypes = { "tofu" }, -- Only activate for .tofu files
	root_markers = { ".tofu", "main.tofu", ".git" }, -- Project root markers for tofu projects
	settings = {
		-- Indexing settings
		indexing = {
			ignoreDirectoryNames = {
				".tofu",
				".git",
				"node_modules",
				".vscode",
				".idea",
				".vscode-test",
			},
			ignorePaths = {},
		},

		-- Warning settings
		ignoreDirectoryNames = {
			".tofu",
			".git",
			"node_modules",
			".vscode",
			".idea",
			".vscode-test",
		},
		ignoreSingleFileWarning = true,

		-- Experimental features
		experimentalFeatures = {
			validateOnSave = true,
			prefillRequiredFields = true,
		},

		-- Validation settings
		validation = {
			enableEnhancedValidation = true,
		},

		-- Code lens toggles
		codeLens = {
			referenceCount = true,
		},

		-- Completion behavior
		completion = {
			prefillRequiredFields = true,
		},

		-- LSP extras
		semanticTokens = true,
		documentLinks = true,

		-- Formatting
		formatting = {
			command = "tofu",
			args = { "fmt", "-" }, -- Format stdin
		},
	},
}
