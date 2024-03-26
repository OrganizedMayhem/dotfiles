local wezterm = require 'wezterm'
local config = {}
if wezterm.config_builder then
  config = wezterm.config_builder()
end

config = {
  color_scheme = 'Solarized Dark - Patched',
  enable_wayland = true,
  font = "Fira Code"
}
wezterm.on('update-right-status', function(window, pane)
  -- "Wed Mar 3 08:14"
  local date = wezterm.strftime '%a %b %-d %H:%M '

  local bat = ''
  for _, b in ipairs(wezterm.battery_info()) do
    bat = '🔋 ' .. string.format('%.0f%%', b.state_of_charge * 100)
  end

  window:set_right_status(wezterm.format {
    { Text = bat .. '   ' .. date },
    })
  end
  )
config.ssh_domains = {
  {
    name = 'sonarqube',
    remote_address = '10.1.1.30',
    local_echo_threshold_ms = 10,
    ssh_option = {
      identityfile = '/home/sevans/sevans_alert',
  },
},
}
return config
