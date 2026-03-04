return {
	cmd = {
		"basedpyright-langserver",
		"--stdio",
	},
	filetypes = {
		"python",
	},
	root_markers = {
		".git",
		"pyproject.toml",
		"setup.py",
		"setup.cfg",
		"requirements.txt",
		"Pipfile",
		"pyrightconfig.json",
		"basedpyrightconfig.json", -- Specific to basedpyright
		".pylintrc",
		".flake8",
		"tox.ini",
		"pytest.ini",
		"poetry.lock",
		"pdm.lock",
	},
	settings = {
		basedpyright = {
			-- Disable specific features if using other tools (like Ruff)
			disableLanguageServices = false,
			disableOrganizeImports = false,
			disableTaggedHints = false,

			analysis = {
				-- Core analysis settings
				typeCheckingMode = "standard", -- "off", "basic", "standard", "strict", "all"
				diagnosticMode = "workspace",
				logLevel = "Information",
				stubPath = "typings", -- Default path for type stubs

				-- Path and import settings
				autoSearchPaths = true,
				extraPaths = {},
				useLibraryCodeForTypes = true,

				-- Code completion and imports
				autoImportCompletions = true,
				diagnosticSeverityOverrides = {
					-- Basedpyright specific/enhanced diagnostics
					reportAny = "none", -- Warns when 'Any' is used (very strict)
					reportExplicitAny = "none",
					reportUnusedImport = "information",
					reportUnusedClass = "information",
					reportUnusedFunction = "information",
					reportUnusedVariable = "information",
					reportDuplicateImport = "warning",
					reportPrivateUsage = "none",

					-- Type checking diagnostics
					reportGeneralTypeIssues = "error",
					reportMissingImports = "error",
					reportImplicitStringConcatenation = "none",
					reportUnusedCallResult = "none",
					reportUnusedCoroutine = "error",
					reportMatchNotExhaustive = "warning",
				},

				-- Enhanced Inlay Hints
				inlayHints = {
					variableTypes = true,
					functionReturnTypes = true,
					callArgumentNames = "none", -- "none", "all", "non-literal"
					parameterTypes = true,
					genericTypes = true,
				},
			},
		},
	},
	single_file_support = true,
	log_level = vim.lsp.protocol.MessageType.Warning,
	capabilities = vim.lsp.protocol.make_client_capabilities(),
	handlers = {},
}
