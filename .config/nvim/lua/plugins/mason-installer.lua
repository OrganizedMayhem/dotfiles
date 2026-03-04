-- lua/plugins/mason.lua

return {
	-- Mason Tool Installer for always-installed tools
	{
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		dependencies = { "mason-org/mason.nvim" },
		opts = {
			ensure_installed = {
				"ansible-language-server",
				"bash-language-server",
				"gopls",
				"helm-ls",
				"jinja-lsp",
				"lua-language-server",
				"basedpyright",
				"ruff",
				"tflint",
				"tofu-ls",
				-- Linters / Formatters
				"ansible-lint",
				"checkstyle",
				"hadolint",
				"kube-linter",
				"shellharden",
				"shellcheck",
				"systemdlint",
				"terraform",
				"tflint",
				"tfsec",
				"trivy",
				"yamlfmt",
				"shfmt",
			},
			run_on_start = true, -- checks/install every startup
			auto_update = true, -- set to true if you want auto-updates every time
			--start_delay = 3000, -- millisecond delay before running installer
			debounce_hours = 5, -- don't run again if run recently
			integrations = {},
		},
	},
}
