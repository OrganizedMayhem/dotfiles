return {
	cmd = { "gopls" }, -- Command to start the language server
	filetypes = { "go", "gomod", "gowork", "gotmpl", "gosum" }, -- File types that this server will handle
	root_markers = { "go.mod", "go.work", ".git" }, -- Markers to identify the root of the project
	settings = { -- Settings for the language server
		gopls = {
			gofumpt = true,
			codelenses = {
				generate = true,
				regenerate_cgo = true,
				run_govulncheck = true,
				test = true,
				tidy = true,
				upgrade_dependency = true,
				vendor = true,
			},
			hints = {
				assignVariableTypes = false,
				compositeLiteralFields = false,
				compositeLiteralTypes = false,
				constantValues = false,
				functionTypeParameters = false,
				parameterNames = false,
				rangeVariableTypes = false,
			},
			-- Nearly every analyzer is on by default; only list the opt-in ones.
			analyses = {
				shadow = true,
			},
			usePlaceholders = true,
			completeUnimported = true,
			staticcheck = true,
			directoryFilters = { "-.git", "-.vscode", "-.idea", "-.vscode-test", "-node_modules" },
			semanticTokens = true,
		},
	},
}
