return {
	"neovim/nvim-lspconfig",
	lazy = true,
	opts = {
		servers = {
			gopls = {
				settings = {
					gopls = {
						analyses = {
							unusedparams = false,
							shadow = true,
							nilness = true,
							unusedwrite = true,
							useany = true,
						},
						staticcheck = true,
						gofumpt = true,
						usePlaceholders = true,
						semanticTokens = true,
						codelenses = {
							gc_details = true,
							generate = true,
							regenerate_cgo = true,
							run_govulncheck = true,
							test = true,
							tidy = true,
							upgrade_dependency = true,
							vendor = true,
						},
						hints = {
							assignVariableTypes = true,
							compositeLiteralFields = true,
							compositeLiteralTypes = true,
							constantValues = true,
							functionTypeParameters = true,
							parameterNames = true,
							rangeVariableTypes = true,
						},
						completeUnimported = true,
						directoryFilters = {
							"-node_modules",
							"-vendor",
							"-tmp",
							"-dist",
							"-build",
						},
						symbolMatcher = "fuzzy",
						symbolStyle = "dynamic",
						experimentalWorkspaceModule = true,
					},
				},
			},
		},
	},
}

