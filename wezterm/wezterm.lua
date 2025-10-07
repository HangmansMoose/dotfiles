-- Pull in the wezterm API
local wezterm = require("wezterm")
local launch_menu = {}
local config = wezterm.config_builder()

-- This is where you actually apply your config choices

--- Get the current operating system
--- @return "windows"| "linux" | "macos"
local function get_os()
    local bin_format = package.cpath:match("%p[\\|/]?%p(%a+)")
    if bin_format == "dll" then
        return "windows"
    elseif bin_format == "so" then
        return "linux"
    end

    return "macos"
end

local host_os = get_os()

-- For example, changing the color scheme:
config.color_scheme = "Black Metal (Mayhem)(base16)"
if host_os == 'windows' then
    config.default_cwd = "G:/dev"
else
    config.default_cwd = "~/dev"
end
config.font = wezterm.font("CaskaydiaMono Nerd Font")
config.font_size = 14
config.animation_fps = 144
config.default_cursor_style = "BlinkingBlock"
config.cursor_blink_ease_in = "Constant"
config.cursor_blink_ease_out = "Constant"
config.cursor_blink_rate = 750
config.scrollback_lines = 20000
config.automatically_reload_config = true
config.max_fps = 120
-- WebGpu allows for the use of DirectX in windows
config.front_end = "WebGpu"

config.colors = {
	cursor_bg = "#00ff33",
	cursor_fg = "#303030",
}
config.default_prog = {
	"pwsh.exe",
	"-nologo",
	"-NoExit",
}

config.launch_menu = {
    { label = "Powershell Core", args = { "pwsh.exe", "-NoLogo", "-NoExit" } },
    { label = "Arch", args = { "wsl.exe", "-d", "archlinux" } },
    { label = "Ubuntu", args = { "wsl.exe", "-d", "Ubuntu-24.04" } }
}

-- This section makes wezterm launch into fullscreen mode
local mux = wezterm.mux

wezterm.on("gui-startup", function()
	local tab, pane, window = mux.spawn_window({})
	window:gui_window():maximize()
end)

-- This listens for the format-window-title event and keeps the windows title as wezterm
require("wezterm").on("format-window-title", function()
	return "Wezterm"
end)

config.enable_tab_bar = false
config.hide_tab_bar_if_only_one_tab = true
config.use_fancy_tab_bar = false

config.leader = { key = "a", mods = "CTRL" }
config.keys = {
    --	Using the ShowLauncherArgs command with the LAUNCH_MENU_ITEMS flag is what allows you to show only what you have defined
    --	in config.launch_menu in the launcher
    { key = 'F3', mods = 'NONE', action = wezterm.action.ShowLauncherArgs{ flags = 'LAUNCH_MENU_ITEMS' } },
    { key = 'F2', mods = 'NONE', action = wezterm.action.ActivateCommandPalette },
	{ key = "-", mods = "LEADER", action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }) },
	{ key = "%", mods = "LEADER|SHIFT", action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
	{ key = "s", mods = "LEADER", action = wezterm.action({ SplitVertical = { domain = "CurrentPaneDomain" } }) },
	{ key = "v", mods = "LEADER", action = wezterm.action({ SplitHorizontal = { domain = "CurrentPaneDomain" } }) },
	{ key = "o", mods = "LEADER", action = "TogglePaneZoomState" },
	{ key = "z", mods = "LEADER", action = "TogglePaneZoomState" },
	{ key = "c", mods = "LEADER", action = wezterm.action({ SpawnTab = "CurrentPaneDomain" }) },
	{ key = "LeftArrow", mods = "CTRL", action = wezterm.action({ ActivatePaneDirection = "Left" }) },
	{ key = "DownArrow", mods = "CTRL", action = wezterm.action({ ActivatePaneDirection = "Down" }) },
	{ key = "UpArrow", mods = "CTRL", action = wezterm.action({ ActivatePaneDirection = "Up" }) },
	{ key = "RightArrow", mods = "CTRL", action = wezterm.action({ ActivatePaneDirection = "Right" }) },
	{ key = "H", mods = "LEADER|SHIFT", action = wezterm.action({ AdjustPaneSize = { "Left", 5 } }) },
	{ key = "J", mods = "LEADER|SHIFT", action = wezterm.action({ AdjustPaneSize = { "Down", 5 } }) },
	{ key = "K", mods = "LEADER|SHIFT", action = wezterm.action({ AdjustPaneSize = { "Up", 5 } }) },
	{ key = "L", mods = "LEADER|SHIFT", action = wezterm.action({ AdjustPaneSize = { "Right", 5 } }) },
	{ key = "1", mods = "LEADER", action = wezterm.action({ ActivateTab = 0 }) },
	{ key = "2", mods = "LEADER", action = wezterm.action({ ActivateTab = 1 }) },
	{ key = "3", mods = "LEADER", action = wezterm.action({ ActivateTab = 2 }) },
	{ key = "4", mods = "LEADER", action = wezterm.action({ ActivateTab = 3 }) },
	{ key = "5", mods = "LEADER", action = wezterm.action({ ActivateTab = 4 }) },
	{ key = "6", mods = "LEADER", action = wezterm.action({ ActivateTab = 5 }) },
	{ key = "7", mods = "LEADER", action = wezterm.action({ ActivateTab = 6 }) },
	{ key = "8", mods = "LEADER", action = wezterm.action({ ActivateTab = 7 }) },
	{ key = "9", mods = "LEADER", action = wezterm.action({ ActivateTab = 8 }) },
	{ key = "&", mods = "LEADER|SHIFT", action = wezterm.action({ CloseCurrentTab = { confirm = true } }) },
	{ key = "d", mods = "LEADER", action = wezterm.action({ CloseCurrentPane = { confirm = true } }) },
	{ key = "x", mods = "LEADER", action = wezterm.action({ CloseCurrentPane = { confirm = true } }) },
}

-- and finally, return the configuration to wezterm
return config
