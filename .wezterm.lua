local wezterm = require("wezterm")

local config = {}

if wezterm.config_builder then
	config = wezterm.config_builder()
end

config.scrollback_lines = 10000
config.front_end = "WebGpu"
config.enable_scroll_bar = true
config.font = wezterm.font("FiraCode Nerd Font")
config.status_update_interval = 1000

local function scheme_for_appearance(appearance)
	if appearance:find("Dark") then
		return "Catppuccin Mocha"
	else
		return "Catppuccin Latte"
	end
end

config.color_scheme = scheme_for_appearance(wezterm.gui.get_appearance())

if wezterm.target_triple == "x86_64-pc-windows-msvc" then
	config.default_domain = "WSL:Ubuntu-24.04"
	config.animation_fps = 144
	config.font_size = 11.0
	config.window_decorations = "INTEGRATED_BUTTONS|RESIZE"
	config.wsl_domains = {
		{
			name = "WSL:Ubuntu-24.04",
			distribution = "Ubuntu-24.04",
			username = "sevans",
			default_cwd = "~",
			default_prog = { "zsh" },
		},
	}
elseif wezterm.target_triple:find("linux") then
	config.enable_wayland = true
	config.font_size = 12.0
	config.window_decorations = "RESIZE"
	config.animation_fps = 60
elseif wezterm.target_triple:find("darwin") then
	config.font_size = 13.0
end

config.keys = {
	{ key = "c", mods = "CTRL|SHIFT", action = wezterm.action.CopyTo("Clipboard") },
	{ key = "v", mods = "CTRL|SHIFT", action = wezterm.action.PasteFrom("Clipboard") },
}

return config
