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

			local select = require("nvim-treesitter-textobjects.select")
			local move = require("nvim-treesitter-textobjects.move")
			local swap = require("nvim-treesitter-textobjects.swap")

			-- Built-in ap/ip, as/is and ab/ib are left alone.
			local objects = {
				f = { "@function", "function" },
				c = { "@class", "class" },
				a = { "@parameter", "parameter" },
				l = { "@loop", "loop" },
				d = { "@conditional", "conditional" },
				e = { "@comment", "comment" },
			}
			for key, obj in pairs(objects) do
				for _, kind in ipairs({ "outer", "inner" }) do
					local lhs = (kind == "outer" and "a" or "i") .. key
					vim.keymap.set({ "x", "o" }, lhs, function()
						select.select_textobject(obj[1] .. "." .. kind, "textobjects")
					end, { desc = kind .. " " .. obj[2] })
				end
			end

			-- ]] / [[ are used by snacks.words for reference jumping.
			local nxo = { "n", "x", "o" }
			vim.keymap.set(nxo, "]m", function()
				move.goto_next_start("@function.outer", "textobjects")
			end, { desc = "Next function start" })
			vim.keymap.set(nxo, "]M", function()
				move.goto_next_end("@function.outer", "textobjects")
			end, { desc = "Next function end" })
			vim.keymap.set(nxo, "[m", function()
				move.goto_previous_start("@function.outer", "textobjects")
			end, { desc = "Prev function start" })
			vim.keymap.set(nxo, "[M", function()
				move.goto_previous_end("@function.outer", "textobjects")
			end, { desc = "Prev function end" })

			vim.keymap.set("n", "<leader>a", function()
				swap.swap_next("@parameter.inner")
			end, { desc = "Swap with next parameter" })
			vim.keymap.set("n", "<leader>A", function()
				swap.swap_previous("@parameter.inner")
			end, { desc = "Swap with previous parameter" })
		end,
	},
}
