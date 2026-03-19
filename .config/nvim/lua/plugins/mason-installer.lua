return {
	{
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		dependencies = { "mason-org/mason.nvim" },
		opts = {
			ensure_installed = {
				-- ── Language Servers ────────────────────────────────────────────
				"ansible-language-server",
				"bash-language-server",
				"docker-compose-language-service", -- compose file LSP
				"gopls",
				"helm-ls",
				"jinja-lsp",
				"lua-language-server",
				"basedpyright",
				"ruff",
				"taplo", -- TOML LSP (terraform vars, configs)
				"tofu-ls",
				"yamlls", -- YAML LSP (k8s manifests, CI/CD)

				-- ── Linters ─────────────────────────────────────────────────────
				"ansible-lint",
				"golangci-lint", -- go: meta-linter (replaces individual go linters)
				"hadolint", -- Dockerfile linter
				"kube-linter", -- k8s manifest linter
				"markdownlint", -- useful for README/runbook editing
				"mypy", -- python: static type checking
				"shellcheck",
				"shellharden",
				"systemdlint",
				"trivy", -- security: vuln scanning (images, IaC, fs)
				"tflint", -- terraform: linter with provider-aware rules

				-- ── Formatters ──────────────────────────────────────────────────
				"gofumpt", -- go: stricter gofmt
				"goimports", -- go: auto-manages imports
				"isort", -- python: import sorting (pairs with ruff)
				"shfmt",
				"yamlfmt",

				-- ── Security / Audit ────────────────────────────────────────────
				"checkov", -- IaC security scanner (tf, k8s, helm, docker)
				"terraform-ls", -- terraform: LSP (complements tofu-ls)
			},

			-- Checks and installs on every startup. Combined with debounce_hours
			-- this means: always ensure tools exist, but don't re-run the full
			-- update check more than once every 5 hours.
			run_on_start = true,
			auto_update = true,
			debounce_hours = 5,

			integrations = {
				["mason-lspconfig"] = false, -- managed separately via lspconfig config
				["mason-nvim-dap"] = false, -- set to true if you add nvim-dap
			},
		},
	},
}
