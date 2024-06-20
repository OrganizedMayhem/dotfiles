local wezterm = require 'wezterm'

local config = {}

-- Use config_builder if available for default settings
if wezterm.config_builder then
  config = wezterm.config_builder()
end
config = {
    color_scheme = "darkmoss",
    front_end = "WebGpu",
    scrollback_lines = 1000,
    animation_fps = 60,
    webgpu_power_preference = "HighPerformance",
--    webgpu_force_fallback_adapter = true,
}
font = "Fira Code"
--max_fps = 60
-- Conditional configuration for different environments
if wezterm.target_triple == "x86_64-pc-windows-msvc" then
  config.enable_wayland = false
  -- Additional Windows-specific settings here
elseif wezterm.target_triple == "x86_64-unknown-linux-gnu" then
  config.enable_wayland = true
  -- Additional Linux-specific settings here
end

-- Custom keyboard shortcuts and mouse bindings
config.keys = {
  {key="c", mods="CTRL|SHIFT", action=wezterm.action{CopyTo="Clipboard"}},
  {key="v", mods="CTRL|SHIFT", action=wezterm.action{PasteFrom="Clipboard"}},
  -- Add more custom key bindings here
}

return config

