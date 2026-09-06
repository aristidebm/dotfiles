-- Attempt to support pywal on wezterm
-- https://github.com/wezterm/wezterm/issues/1036
--
-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This table will hold the configuration.
local config = {}

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
	config = wezterm.config_builder()
end

-- config.font = wezterm.font('VictorMono Nerd Font Mono')
-- config.font = wezterm.font_with_fallback({
--   "Iosevka"
-- 	-- "JetBrains Mono",
--   -- "IBM Plex Mono"
-- 	-- "JetBrainsMono Nerd Font Mono",
-- })

-- enable this to support a wide range of Control
-- key combination like <C;> for exemple
-- source: https://wezfurlong.org/wezterm/config/key-encoding.html#csi-ufixtermslibtickit
config.enable_csi_u_key_encoding = true

config.font_size = 20.0

-- Disable ligatures
-- config.harfbuzz_features = { 'calt=0', 'clig=0', 'liga=0' }

-- For example, changing the color scheme:
config.color_scheme = "rose-pine"
-- config.color_scheme = 'Modus Operandi (Gogh)'

config.enable_tab_bar = false

config.enable_scroll_bar = false

-- Remove padding
config.window_padding = {
	-- right=0,
	-- left=0,
	bottom = 0,
}
config.audible_bell = "Disabled"

-- Deactivate this setting and hit CTRL+SHIFT+P in
-- the current pane to 'reset terminal' in case you
-- are experiencing System paste (CTRL+SHIFT+V) problem
config.disable_default_key_bindings = true

-- config.window_background_opacity = 0.90
config.adjust_window_size_when_changing_font_size = false

-- config.window_background_image_hsb = {
--   -- Darken the background image by reducing it to 1/3rd
--   brightness = 0.3,
--
--   -- You can adjust the hue by scaling its value.
--   -- a multiplier of 1.0 leaves the value unchanged.
--   hue = 1.0,
--
--   -- You can adjust the saturation also.
--   saturation = 1.0,
-- }

config.keys = {
	{
		key = "v",
		mods = "CTRL|SHIFT",
		action = wezterm.action.PasteFrom("Clipboard"),
	},
	{
		key = "k",
		mods = "CTRL|SHIFT",
		action = wezterm.action.IncreaseFontSize,
	},
	{
		key = "j",
		mods = "CTRL|SHIFT",
		action = wezterm.action.DecreaseFontSize,
	},
	{
		key = "=",
		mods = "CTRL",
		action = wezterm.action.ResetFontSize,
	},
	{
		key = "P",
		mods = "CTRL|SHIFT",
		action = wezterm.action.ActivateCommandPalette,
	},
}

config.max_fps = 120

return config
