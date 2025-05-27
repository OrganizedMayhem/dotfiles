return {
	"nvim-treesitter/nvim-treesitter",
	branch = "main",
	build = ":TSUpdate", -- This command ensures parsers are updated/installed
	config = function()
		require("nvim-treesitter.configs").setup({
			-- A list of parser names, or "all" (the listed parsers MUST always be installed)
			ensure_installed = {
				"lua",
				"go",
				"python",
				"vim",
				"vimdoc",
				"json",
				"bash",
				-- Add more language parsers you want to install here
			},
			-- Install parsers synchronously (only applied to `ensure_installed`)
			sync_install = false,

			highlight = {
				enable = true, -- Enable syntax highlighting
			},
			indent = {
				enable = false, -- Enable indentation
			},
			-- You can also disable specific languages from being highlighted/indented if needed
			-- disable = { "tex", "go" },
		})
	end,
}
