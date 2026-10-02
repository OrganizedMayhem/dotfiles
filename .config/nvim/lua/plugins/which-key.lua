return {
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		-- group labels and icons come from the keymap registry (lua/config/keymaps)
		opts = function()
			return { spec = require("config.keymaps").which_key_spec() }
		end,
	},
}
