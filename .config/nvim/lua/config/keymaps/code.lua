local function select(query)
	return function()
		require("nvim-treesitter-textobjects.select").select_textobject(query, "textobjects")
	end
end

local function swap(dir)
	return function()
		require("nvim-treesitter-textobjects.swap")["swap_" .. dir]("@parameter.inner")
	end
end

local xo = { "x", "o" }

return {
	name = "Code",
	plugin = "treesitter-textobjects",
	icon = { icon = "\u{f040} ", color = "orange" },
	prefixes = { ["<leader>c"] = "code" },
	maps = {
		{ "<leader>cf", function() require("conform").format({ lsp_format = "fallback" }) end, desc = "Format current file", plugin = "conform" },
		{ "<leader>cR", function() Snacks.rename.rename_file() end, desc = "Rename File", plugin = "snacks" },
		{ "<leader>a", swap("next"), desc = "Swap with next parameter" },
		{ "<leader>A", swap("previous"), desc = "Swap with previous parameter" },

		-- text objects ("a" outer, "i" inner); built-in ap/ip, as/is, ab/ib are untouched
		{ "af", select("@function.outer"), desc = "outer function", mode = xo },
		{ "if", select("@function.inner"), desc = "inner function", mode = xo },
		{ "ac", select("@class.outer"), desc = "outer class", mode = xo },
		{ "ic", select("@class.inner"), desc = "inner class", mode = xo },
		{ "aa", select("@parameter.outer"), desc = "outer parameter", mode = xo },
		{ "ia", select("@parameter.inner"), desc = "inner parameter", mode = xo },
		{ "al", select("@loop.outer"), desc = "outer loop", mode = xo },
		{ "il", select("@loop.inner"), desc = "inner loop", mode = xo },
		{ "ad", select("@conditional.outer"), desc = "outer conditional", mode = xo },
		{ "id", select("@conditional.inner"), desc = "inner conditional", mode = xo },
		{ "ae", select("@comment.outer"), desc = "outer comment", mode = xo },
		{ "ie", select("@comment.inner"), desc = "inner comment", mode = xo },
		{ "an", desc = "Parent syntax node", mode = xo, ref = true, plugin = "nvim" },
		{ "in", desc = "Child syntax node", mode = xo, ref = true, plugin = "nvim" },

		-- Neovim defaults
		{ "gcc", desc = "Toggle comment line (gc{motion} for a range)", ref = true, plugin = "nvim" },
		{ "gc", desc = "Toggle comment on selection", mode = "x", ref = true, plugin = "nvim" },
		{ "gx", desc = "Open path or URL under cursor", mode = { "n", "x" }, ref = true, plugin = "nvim" },
		{ "]<Space>", desc = "Add empty line below", ref = true, plugin = "nvim" },
		{ "[<Space>", desc = "Add empty line above", ref = true, plugin = "nvim" },
	},
}
