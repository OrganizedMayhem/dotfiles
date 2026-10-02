-- nvim-treesitter `main` branch: it only installs parsers/queries.
-- Highlighting, folding and indent are wired up by hand below using Neovim's built-in APIs.
local parsers = {
	"bash",
	"diff",
	"dockerfile",
	"go",
	"gomod",
	"gosum",
	"gowork",
	"hcl",
	"helm",
	"jinja",
	"json",
	"lua",
	"markdown",
	"markdown_inline",
	"python",
	"query",
	"regex",
	"terraform",
	"toml",
	"vim",
	"vimdoc",
	"yaml",
}

return {
	{
		"nvim-treesitter/nvim-treesitter",
		branch = "main",
		lazy = false, -- main branch does not support lazy-loading
		build = ":TSUpdate",
		config = function()
			local ts = require("nvim-treesitter")
			ts.install(parsers) -- async, no-op for parsers already installed

			vim.api.nvim_create_autocmd("FileType", {
				group = vim.api.nvim_create_augroup("treesitter-start", { clear = true }),
				callback = function(event)
					if not pcall(vim.treesitter.start, event.buf) then
						return -- no parser for this filetype
					end
					vim.bo[event.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
				end,
			})
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter-textobjects",
		branch = "main",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		event = { "BufReadPost", "BufNewFile" },
		config = function()
			require("nvim-treesitter-textobjects").setup({
				select = {
					-- Automatically jump forward to textobj, similar to targets.vim lookahead
					lookahead = true,
					selection_modes = {
						["@parameter.outer"] = "v",
						["@function.outer"] = "V",
						["@class.outer"] = "V",
					},
				},
				move = {
					set_jumps = true, -- whether to set jumps in the jumplist
				},
			})

			-- keymaps: lua/config/keymaps/code.lua and nav.lua
		end,
	},
}
