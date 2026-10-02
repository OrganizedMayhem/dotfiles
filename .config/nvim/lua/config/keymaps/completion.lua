-- blink.cmp uses its "default" keymap preset (plus <C-f> unmapped, see plugins/blink.lua);
-- these entries only document it.
local i = "i"

return {
	name = "Completion",
	plugin = "blink.cmp",
	icon = { icon = "\u{f11c} ", color = "yellow" },
	maps = {
		{ "<C-Space>", desc = "Show menu / toggle documentation", mode = i, ref = true },
		{ "<C-y>", desc = "Accept selected item", mode = i, ref = true },
		{ "<C-e>", desc = "Cancel", mode = i, ref = true },
		{ "<C-n>", desc = "Next item (<C-p> prev, also <Down>/<Up>)", mode = i, ref = true },
		{ "<C-b>", desc = "Scroll documentation up", mode = i, ref = true },
		{ "<C-k>", desc = "Toggle signature help", mode = i, ref = true },
		{ "<Tab>", desc = "Next snippet placeholder (<S-Tab> prev)", mode = { "i", "s" }, ref = true },
	},
}
