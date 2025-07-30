local wezterm = require("wezterm")

-- Use wezterm.config_builder() for a new configuration
local config = wezterm.config_builder()

-- General Settings
config.automatically_reload_config = true
config.scrollback_lines = 10000
config.enable_scroll_bar = true
wezterm.font("FiraCode Nerd Font", {
    weight = "Bold",      -- or "Light", "Medium", "SemiBold", etc.
    style = "Oblique",    -- or "Normal", "Oblique"
    stretch = "Expanded", -- or "Normal", "Expanded", "SemiCondensed", etc.
})
config.status_update_interval = 1000
config.front_end = "WebGpu"

-- Color Scheme based on System Appearance
-- This function is clear and concise, no changes needed here.
local function scheme_for_appearance(appearance)
    if appearance:find("Dark") then
        return "Catppuccin Mocha"
    else
        return "Catppuccin Mocha"
    end
end
config.color_scheme = scheme_for_appearance(wezterm.gui.get_appearance())

-- Platform-Specific Settings
if wezterm.target_triple == "x86_64-pc-windows-msvc" then
    -- Windows (MSVC build)
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
    -- Linux (handles various Linux builds, e.g., glibc, musl)
    config.enable_wayland = false
    config.font_size = 16.0
    config.window_decorations = "RESIZE"
    config.animation_fps = 60
elseif wezterm.target_triple:find("darwin") then
    -- macOS
    config.font_size = 13.0
    -- macOS typically handles window decorations itself, so "RESIZE" is often implied
    -- if you want to explicitly allow resizing, you can add:
    -- config.window_decorations = "RESIZE"
end

-- Keybindings
-- These are standard and well-defined, no changes needed.
config.keys = {
    { key = "c", mods = "CTRL|SHIFT", action = wezterm.action.CopyTo("Clipboard") },
    { key = "v", mods = "CTRL|SHIFT", action = wezterm.action.PasteFrom("Clipboard") },
}

return config
