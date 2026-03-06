return {
	cmd = { "basedpyright-langserver", "--stdio" }, -- Command to start the language server
	filetypes = { "python" },                       -- File types that this server will handle
	root_markers = { "pyproject.toml", "setup.py", "setup.cfg", "requirements.txt", "Pipfile", "pyrightconfig.json", ".git" }, -- Markers to identify the root of the project
	settings = {
		basedpyright = {
			-- Analysis settings
			analysis = {
				autoSearchPaths = true,        -- Automatically add common search paths
				useLibraryCodeForTypes = true, -- Use library source code for type information
				diagnosticMode = "openFilesOnly", -- Analyze open files only (use "workspace" for full project)
				typeCheckingMode = "basic",    -- Type checking strictness: off, basic, standard, strict, all
				autoImportCompletions = true,     -- Enable auto-import completions
				completeFunctionParens = true,    -- Auto-insert parentheses on function completions

				-- Diagnostic severity overrides
				reportMissingImports = "warning",    -- Warn on missing imports instead of error
				reportMissingTypeStubs = "none",     -- Suppress missing type stub warnings
				reportUnknownVariableType = "none",  -- Suppress unknown variable type errors
				reportUnknownMemberType = "none",    -- Suppress unknown member type errors
				reportUnknownArgumentType = "none",  -- Suppress unknown argument type errors
			},

			-- Inlay hints
			inlayHints = {
				variableTypes = true,        -- Show inferred variable types
				functionReturnTypes = true,  -- Show inferred function return types
				callArgumentNames = true,    -- Show argument names in calls
				genericTypes = false,        -- Show generic type parameters
			},
		},
	},
}
