local wezterm = require 'wezterm'

local fira_font = "FiraCode Nerd Font"

return {
    font = wezterm.font(fira_font),
    color_scheme = 'Solarized (dark) (terminal.sexy)',
    font_rules = {
        { intensity = "Bold", font = wezterm.font(fira_font, { bold = true }) },
        { italic = true, intensity = "Bold", font = wezterm.font(fira_font, { bold = true, italic = true }) },
        { italic = true, font = wezterm.font(fira_font, { italic = true }) }
    },

    -- default_prog = {"zsh"},
    send_composed_key_when_left_alt_is_pressed = false,
    send_composed_key_when_right_alt_is_pressed = true,

    keys = {
        -- Rebind OPT-Left, OPT-Right as ALT-b, ALT-f respectively to match Terminal.app behavior
        { key = "LeftArrow", mods = "OPT", action = { SendKey = { key = "b", mods = "ALT" } } },
        { key = "RightArrow", mods = "OPT", action = { SendKey = { key = "f", mods = "ALT" } } }
    },

    enable_wayland = true,
    max_fps = 60,
    front_end = 'WebGpu',  -- changed from 'OpenGL' to 'WebGPU'
    hide_tab_bar_if_only_one_tab = true,
    window_padding = { left = 2, right = 2, top = 2, bottom = 2 },
    window_close_confirmation = "NeverPrompt"
}
