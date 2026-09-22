return {
	cmd = {
		"lua-language-server",
	},
	filetypes = {
		"lua",
	},
	root_markers = {
		".git",
		".luacheckrc",
		".luarc.json",
		".luarc.jsonc",
		".stylua.toml",
		"selene.toml",
		"selene.yml",
		"stylua.toml",
	},
	settings = {
		Lua = {
			runtime = {
				version = "LuaJIT",
			},
			diagnostics = {
				globals = { "vim", "Snacks", "describe", "it", "before_each", "after_each" },
			},
			workspace = {
				-- Only the Neovim runtime, luv, and snacks types; indexing every plugin dir slows startup a lot.
				library = {
					vim.env.VIMRUNTIME,
					"${3rd}/luv/library",
					vim.fn.stdpath("data") .. "/lazy/snacks.nvim",
				},
				checkThirdParty = false,
			},
			telemetry = {
				enable = false,
			},
		},
	},
}
