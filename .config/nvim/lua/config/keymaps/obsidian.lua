-- obsidian.nvim sets these itself in vault notes / its picker (see plugins/obsidian.lua).
return {
	name = "Obsidian",
	plugin = "obsidian",
	icon = { icon = "\u{f0219} ", color = "purple" },
	maps = {
		{ "<CR>", desc = "Smart action: follow link, toggle checkbox", ref = true },
		{ "]o", desc = "Next link in note ([o prev)", ref = true },
		{ "<C-x>", desc = "Picker: new note from query / tag the note", mode = "i", ref = true },
		{ "<C-l>", desc = "Picker: insert link / insert tag", mode = "i", ref = true },
	},
}
