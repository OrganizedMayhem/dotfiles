local wezterm = require 'wezterm'

local config = {}

-- Use config_builder if available for default settings
if wezterm.config_builder then
  config = wezterm.config_builder()
end
config = {
    color_scheme = "Solarized Dark - Patched",
    front_end = "OpenGL",
    harfbuzz_features = {"kern", "liga"},
    scrollback_lines = 1000,
}
font = "Fira Code"
max_fps = 144
-- Conditional configuration for different environments
if wezterm.target_triple == "x86_64-pc-windows-msvc" then
  config.enable_wayland = false
  -- Additional Windows-specific settings here
elseif wezterm.target_triple == "x86_64-unknown-linux-gnu" then
  config.enable_wayland = true
  -- Additional Linux-specific settings here
end

-- Optimized battery information display for multiple batteries
wezterm.on('update-right-status', function(window, pane)
  local date = wezterm.strftime '%a %b %-d %H:%M '
  local bat_info = {}

  for _, b in ipairs(wezterm.battery_info()) do
    table.insert(bat_info, '🔋 ' .. string.format('%.0f%%', b.state_of_charge * 100))
  end

  local bat = table.concat(bat_info, " ")

  window:set_right_status(wezterm.format {
    {Text = bat .. '   ' .. date},
  })
end)

-- Custom keyboard shortcuts and mouse bindings
config.keys = {
  {key="c", mods="CTRL|SHIFT", action=wezterm.action{CopyTo="Clipboard"}},
  {key="v", mods="CTRL|SHIFT", action=wezterm.action{PasteFrom="Clipboard"}},
  -- Add more custom key bindings here
}

return config

