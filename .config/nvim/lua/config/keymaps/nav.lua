local function move(fn, query)
	return function()
		require("nvim-treesitter-textobjects.move")[fn](query, "textobjects")
	end
end

local nxo = { "n", "x", "o" }

return {
	name = "Navigate",
	plugin = "treesitter-textobjects",
	icon = { icon = "\u{f14e} ", color = "azure" },
	maps = {
		-- ]] / [[ belong to snacks.words; Go and some other ftplugins override them with section jumps
		{ "]]", function() Snacks.words.jump(vim.v.count1) end, desc = "Next Reference", mode = { "n", "t" }, plugin = "snacks" },
		{ "[[", function() Snacks.words.jump(-vim.v.count1) end, desc = "Prev Reference", mode = { "n", "t" }, plugin = "snacks" },
		{ "]m", move("goto_next_start", "@function.outer"), desc = "Next function start", mode = nxo },
		{ "]M", move("goto_next_end", "@function.outer"), desc = "Next function end", mode = nxo },
		{ "[m", move("goto_previous_start", "@function.outer"), desc = "Prev function start", mode = nxo },
		{ "[M", move("goto_previous_end", "@function.outer"), desc = "Prev function end", mode = nxo },

		-- Neovim defaults
		{ "]d", desc = "Next diagnostic ([d prev, ]D last, [D first)", ref = true, plugin = "nvim" },
		{ "]q", desc = "Next quickfix ([q prev, ]Q last, [Q first)", ref = true, plugin = "nvim" },
		{ "]l", desc = "Next loclist ([l prev, ]L last, [L first)", ref = true, plugin = "nvim" },
		{ "]b", desc = "Next buffer ([b prev, ]B last, [B first)", ref = true, plugin = "nvim" },
		{ "]a", desc = "Next argument ([a prev)", ref = true, plugin = "nvim" },
		{ "]t", desc = "Next tag ([t prev)", ref = true, plugin = "nvim" },
		{ "]n", desc = "Select next node ([n prev, ]N/[N sibling)", mode = "x", ref = true, plugin = "nvim" },
	},
}
