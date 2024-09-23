local wezterm = require 'wezterm'

local config = {}

-- Use config_builder if available for default settings
if wezterm.config_builder then
  config = wezterm.config_builder()
end

-- Base configuration
config.color_scheme = "darkmoss"
config.scrollback_lines = 1000
config.animation_fps = 60
font = "Fira Code"
config.status_update_interval = 100
-- Use WebGpu if available, otherwise fall back to OpenGL
if wezterm.gui_available and wezterm.gui.get_front_end_name() == "WebGpu" then
  config.front_end = "WebGpu"
  config.webgpu_power_preference = "HighPerformance"
  -- Optional fallback adapter setting can be uncommented if needed
  -- config.webgpu_force_fallback_adapter = true
else
  config.front_end = "OpenGL"
end

-- Platform-specific configuration
if wezterm.target_triple == "x86_64-pc-windows-msvc" then
  config.enable_wayland = false
  -- Additional Windows-specific settings here
elseif wezterm.target_triple == "x86_64-unknown-linux-gnu" or wezterm.target_triple == "aarch64-unknown-linux-gnu" then
  config.enable_wayland = true
  -- Additional Linux-specific settings here
elseif wezterm.target_triple == "x86_64-apple-darwin" or wezterm.target_triple == "aarch64-apple-darwin" then
  -- MacOS-specific settings
  config.enable_wayland = false
  -- Additional MacOS-specific settings here
end

-- Custom keyboard shortcuts and mouse bindings
config.keys = {
  {key="c", mods="CTRL|SHIFT", action=wezterm.action{CopyTo="Clipboard"}},
  {key="v", mods="CTRL|SHIFT", action=wezterm.action{PasteFrom="Clipboard"}},
  -- Add more custom key bindings here
}

-- Dynamic tab and pane titles based on hostname and current working directory
wezterm.on("update-right-status", function(window, pane)
  -- Fetch the hostname
  local hostname = wezterm.hostname()

  -- Fetch the current working directory
  local cwd_uri = pane:get_current_working_dir()
  local cwd = ""

  if cwd_uri then
    -- Extract the path component of the file URI
    cwd = wezterm.uri_parse(cwd_uri).path or ""
  end

  -- Update the tab and pane title
  local title = hostname .. " : " .. cwd
  window:set_right_status(title)
  window:set_title(title)
end)

-- Set tab and pane title update events
--config.pane_title = "wezterm.pane-title"
--config.tab_title = "wezterm.tab-title"

return config

