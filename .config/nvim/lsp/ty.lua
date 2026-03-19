return {
	cmd = { "ty", "server" }, -- Command to start the language server
	filetypes = { "python" }, -- File types that this server will handle
	root_markers = {
		"pyproject.toml",
		"setup.py",
		"setup.cfg",
		"requirements.txt",
		"Pipfile",
		"pyrightconfig.json",
		".git",
	}, -- Markers to identify the root of the project
	settings = {
		ty = {
			diagnosticMode = "workspace",
			showSyntaxErrors = true,
			disableLanguageServices = false,
			inlayHints = {
				variableTypes = true,
				callArgumentNames = true,
			},
			completions = {
				autoImport = true,
			},
			configuration = {
				rules = {
					-- Promote commonly noisy-but-important rules to errors.
					-- Adjust these based on the codebase you're working in.
					["unresolved-import"] = "error",
					["unresolved-reference"] = "error",
					["possibly-unbound"] = "warn",
					["invalid-return-type"] = "warn",
					["invalid-argument-type"] = "warn",
				},
			},
		},
	},
}
