return {
	cmd = {
		"pyright-langserver",
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
		".pylintrc",
		".flake8",
		"tox.ini",
		"pytest.ini",
		"poetry.lock",
		"pdm.lock",
	},
	settings = {
		-- Main pyright settings
		pyright = {
			-- Disable specific features (useful if using other tools)
			disableLanguageServices = false, -- Disables hover, completion, etc.
			disableOrganizeImports = false, -- Disables organize imports command
			disableTaggedHints = false, -- Disables grayed out unreachable code

			-- Deprecated but still supported
			openFilesOnly = nil, -- Use python.analysis.diagnosticMode instead
			useLibraryCodeForTypes = nil, -- Use python.analysis.useLibraryCodeForTypes instead
			typeCheckingMode = nil, -- Use python.analysis.typeCheckingMode instead
		},

		-- Python analysis settings
		python = {
			-- Python interpreter path
			pythonPath = nil, -- Auto-detected if nil, or specify: ".venv/bin/python"

			-- Virtual environment settings (less robust than pythonPath)
			venvPath = nil, -- Path to directory containing venvs: "./venvs"
			venv = nil, -- Name of venv to use: "myproject"

			analysis = {
				-- Core analysis settings
				typeCheckingMode = "basic", -- "off", "basic", "standard", "strict"
				diagnosticMode = "openFilesOnly", -- "openFilesOnly", "workspace"
				logLevel = "Information", -- "Error", "Warning", "Information", "Trace"

				-- Path and import settings
				autoSearchPaths = true, -- Auto-add src/ and similar paths
				extraPaths = {}, -- Additional import paths: {"./lib", "./vendor"}
				typeshedPaths = {}, -- Custom typeshed paths (rarely needed)

				-- Code completion and imports
				autoImportCompletions = true, -- Enable auto-import suggestions
				useLibraryCodeForTypes = true, -- Parse library code for types

				-- Diagnostic severity overrides
				diagnosticSeverityOverrides = {
					-- Type checking diagnostics
					reportGeneralTypeIssues = "error", -- General type problems
					reportPropertyTypeMismatch = "error", -- Property type mismatches
					reportFunctionMemberAccess = "error", -- Invalid function member access
					reportMissingImports = "error", -- Missing imports
					reportMissingModuleSource = "warning", -- Missing module source
					reportMissingTypeStubs = "none", -- Missing type stubs
					reportImportCycles = "error", -- Circular imports
					reportUnusedImport = "information", -- Unused imports
					reportUnusedClass = "information", -- Unused classes
					reportUnusedFunction = "information", -- Unused functions
					reportUnusedVariable = "information", -- Unused variables
					reportDuplicateImport = "warning", -- Duplicate imports
					reportWildcardImportFromLibrary = "warning", -- Wildcard imports from libraries

					-- Optional type checking
					reportOptionalSubscript = "error", -- Optional[x][y] without check
					reportOptionalMemberAccess = "error", -- Optional.attr without check
					reportOptionalCall = "error", -- Optional() without check
					reportOptionalIterable = "error", -- for x in Optional without check
					reportOptionalContextManager = "error", -- with Optional without check
					reportOptionalOperand = "error", -- Optional + x without check

					-- Variable analysis
					reportUndefinedVariable = "error", -- Undefined variables
					reportUnboundVariable = "error", -- Unbound variables
					reportInvalidStringEscapeSequence = "error", -- Invalid escape sequences
					reportInvalidTypeVarUse = "error", -- Invalid TypeVar usage
					reportSelfClsParameterName = "warning", -- self/cls parameter naming
					reportConstantRedefinition = "error", -- Constant redefinition

					-- Call analysis
					reportIncompatibleMethodOverride = "error", -- Method override issues
					reportIncompatibleVariableOverride = "error", -- Variable override issues
					reportUntypedBaseClass = "none", -- Untyped base classes
					reportUntypedClassDecorator = "none", -- Untyped class decorators
					reportUntypedFunctionDecorator = "none", -- Untyped function decorators
					reportUntypedNamedTuple = "none", -- Untyped NamedTuple

					-- Argument analysis
					reportCallInDefaultInitializer = "none", -- Calls in default initializers
					reportUnnecessaryIsInstance = "none", -- Unnecessary isinstance
					reportUnnecessaryCast = "none", -- Unnecessary cast
					reportAssertAlwaysTrue = "warning", -- Assert always true
					reportUnnecessaryComparison = "none", -- Unnecessary comparisons
					reportUnnecessaryContains = "none", -- Unnecessary contains
					reportUnusedCallResult = "none", -- Unused call results

					-- Advanced checks
					reportPrivateUsage = "none", -- Private member usage
					reportPrivateImportUsage = "error", -- Private import usage
					reportTypeCommentUsage = "none", -- Type comment usage
					reportIncompatibleMethodOverride = "error", -- Method override compatibility
					reportInvalidStubStatement = "none", -- Invalid stub statements
					reportIncompleteStub = "none", -- Incomplete stub files
					reportUnsupportedDunderAll = "warning", -- Unsupported __all__
					reportUnusedCoroutine = "error", -- Unused coroutines

					-- Experimental and strict checks
					reportMatchNotExhaustive = "none", -- Non-exhaustive match statements
					reportShadowedImports = "none", -- Shadowed imports
					reportUninitializedInstanceVariable = "none", -- Uninitialized instance vars
					reportInvalidTypeForm = "error", -- Invalid type forms
					reportMissingParameterType = "none", -- Missing parameter types
					reportMissingTypeArgument = "none", -- Missing type arguments
					reportUnknownParameterType = "none", -- Unknown parameter types
					reportUnknownVariableType = "none", -- Unknown variable types
					reportUnknownMemberType = "none", -- Unknown member types
					reportUnknownArgumentType = "none", -- Unknown argument types
					reportUnknownLambdaType = "none", -- Unknown lambda types
					reportInvalidTypeVarUse = "error", -- Invalid TypeVar usage
					reportOverlappingOverloads = "error", -- Overlapping overloads
					reportMissingSuperCall = "none", -- Missing super() calls
					reportPropertyTypeMismatch = "error", -- Property type mismatch
					reportUninitializedInstanceVariable = "none", -- Uninitialized instance variables
					reportInvalidStringEscapeSequence = "error", -- Invalid string escapes
					reportUnknownParameterType = "none", -- Unknown parameter types
					reportMissingParameterType = "none", -- Missing parameter types
					reportCallInDefaultInitializer = "none", -- Calls in default initializers
					reportUnnecessaryIsInstance = "none", -- Unnecessary isinstance calls
					reportUnnecessaryCast = "none", -- Unnecessary cast calls
					reportUnnecessaryComparison = "none", -- Unnecessary comparisons
					reportUnnecessaryContains = "none", -- Unnecessary contains calls
					reportImplicitStringConcatenation = "none", -- Implicit string concatenation
					reportInvalidStubStatement = "none", -- Invalid stub statements
					reportIncompleteStub = "none", -- Incomplete stub files
					reportUnsupportedDunderAll = "warning", -- Unsupported __all__ usage
					reportUnusedCallResult = "none", -- Unused call results
					reportUnusedCoroutine = "error", -- Unused coroutines
					reportUnusedExpression = "warning", -- Unused expressions
					reportUnnecessaryTypeIgnoreComment = "none", -- Unnecessary type: ignore
					reportMatchNotExhaustive = "none", -- Non-exhaustive match
				},

				-- Experimental inlay hints (if supported by your LSP client)
				inlayHints = {
					variableTypes = true, -- Show variable type hints
					functionReturnTypes = true, -- Show return type hints
					callArgumentNames = false, -- Show argument names in calls
					parameterTypes = false, -- Show parameter type hints
					genericTypes = false, -- Show generic type hints
				},

				-- Indexing settings (for better performance)
				indexing = true, -- Enable indexing for better performance
				packageIndexDepths = { -- Control indexing depth per package
					-- { name = "pandas", depth = 2 },
					-- { name = "numpy", depth = 1 },
				},
			},
		},
	},
	single_file_support = true,
	log_level = vim.lsp.protocol.MessageType.Warning,

	-- Additional capabilities (for nvim-cmp integration)
	capabilities = vim.lsp.protocol.make_client_capabilities(),

	-- Custom handlers (optional)
	handlers = {
		-- Custom handling for specific LSP methods
		-- ["textDocument/publishDiagnostics"] = vim.lsp.with(
		--   vim.lsp.diagnostic.on_publish_diagnostics, {
		--     virtual_text = true,
		--     signs = true,
		--     underline = true,
		--     update_in_insert = false,
		--   }
		-- ),
	},
}
