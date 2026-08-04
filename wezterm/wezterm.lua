-- Pull in the wezterm API
local wezterm = require("wezterm")
local launch_menu = {}
local config = wezterm.config_builder()
local act = wezterm.action

-- This is where you actually apply your config choices

--- Get the current operating system
--- @return "windows"| "linux" | "macos"
--local function get_os()
--    local bin_format = package.cpath:match("%p[\\|/]?%p(%a+)")
--    if bin_format == "dll" then
--        return "windows"
--    elseif bin_format == "so" then
--        return "linux"
--    end
--
--    return "macos"
--end

local function get_os()
    local cpath = package.cpath
    if cpath:match("%.dll") then
        return "Windows"
    elseif cpath:match("%.dylib") then
        return "macOS"
    else
        return "Linux"
    end
end

local host_os = get_os()

-- For example, changing the color scheme:
--config.color_scheme = "Tomorrow Night Bright"
if host_os == 'Windows' then
    config.default_cwd = "G:/"
else
    config.default_cwd = "~/dev"
end

-- wezterm.GLOBAL survives config reloads; a plain local table wouldn't
wezterm.GLOBAL.tab_titles = wezterm.GLOBAL.tab_titles or {}

local function basename(s)
  s = string.gsub(s or '', '(.*[/\\])(.*)', '%2')
  return (string.gsub(s, '%.exe$', ''))  -- Windows
end

wezterm.on('format-tab-title', function(tab)
  -- respect manual renames (tab:set_title / OSC 0;2)
  if tab.tab_title and #tab.tab_title > 0 then
    return ' ' .. tab.tab_title .. ' '
  end

  local key = tostring(tab.tab_id)
  local cached = wezterm.GLOBAL.tab_titles[key]
  if cached then
    return ' ' .. cached .. ' '
  end

  local pane = tab.active_pane
  local name = basename(pane.foreground_process_name)
  if name == '' then
    name = pane.domain_name or pane.title  -- ssh/mux panes have no local proc
  end
  if name == '' then
    return ' shell '  -- not resolved yet, don't cache; retry next frame
  end

  wezterm.GLOBAL.tab_titles[key] = name
  return ' ' .. name .. ' '
end)

config.font = wezterm.font("CaskaydiaMono Nerd Font")
config.font_size = 14
config.animation_fps = 144
config.default_cursor_style = "BlinkingBlock"
config.cursor_blink_ease_in = "Constant"
config.cursor_blink_ease_out = "Constant"
config.cursor_blink_rate = 500
config.scrollback_lines = 20000
config.automatically_reload_config = true
config.max_fps = 120
--config.term = "xterm-256"
-- WebGpu allows for the use of DirectX in windows
config.webgpu_preferred_adapter = {
        backend = "Dx12",
        device = 9373,
        device_type = "DiscreteGpu",
        driver = "32.0.16.1074",
        name = "NVIDIA GeForce RTX 3070 Laptop GPU",
        vendor = 4318,
}
config.front_end = "WebGpu"

config.default_prog = { "pwsh.exe" }

config.launch_menu = {
    { label = "pwsh", args = { "pwsh.exe"} },
    { label = "pwsh vsdev", args = { "pwsh.exe", "-NoExit", "-c", "G:\\dev_tools\\scripts\\vsdev.ps1" } },
    { label = "Ubuntu26", args = { "wsl.exe", "-d", "Ubuntu26.04" } },
    { label = "Arch", args = { "wsl.exe", "-d", "archlinux" } },
    { label = "Fedora44", args = { "wsl.exe", "-d", "FedoraLinux-44" } },
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

config.window_decorations = "INTEGRATED_BUTTONS|RESIZE"
config.enable_tab_bar = true
config.hide_tab_bar_if_only_one_tab = false
config.use_fancy_tab_bar = true
-- config.tab_bar_at_bottom = true
config.window_frame = {
	active_titlebar_bg = "#050505",
	inactive_titlebar_bg = "#050505",
	active_titlebar_fg = "#FFA717"
}
config.colors = {
	background = '#000000',
	cursor_bg = "#7e7e7e",
	cursor_fg = "#1a1a1a",
}

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
	{
		key = "E",
		mods = "CTRL|SHIFT|ALT",
		action = wezterm.action.EmitEvent("toggle-colorscheme"),
	},
	{
		key = "h",
		mods = "CTRL|SHIFT|ALT",
		action = wezterm.action.SplitPane({
			direction = "Right",
			size = { Percent = 50 },
		}),
	},
	{
		key = "v",
		mods = "CTRL|SHIFT|ALT",
		action = wezterm.action.SplitPane({
			direction = "Down",
			size = { Percent = 50 },
		}),
	},
	{
		key = "U",
		mods = "CTRL|SHIFT",
		action = act.AdjustPaneSize({ "Left", 5 }),
	},
	{
		key = "I",
		mods = "CTRL|SHIFT",
		action = act.AdjustPaneSize({ "Down", 5 }),
	},
	{
		key = "O",
		mods = "CTRL|SHIFT",
		action = act.AdjustPaneSize({ "Up", 5 }),
	},
	{
		key = "P",
		mods = "CTRL|SHIFT",
		action = act.AdjustPaneSize({ "Right", 5 }),
	},
	{ key = "9", mods = "CTRL", action = act.PaneSelect },
	{ key = "L", mods = "CTRL", action = act.ShowDebugOverlay },
	{
		key = "O",
		mods = "CTRL|ALT",
		-- toggling opacity
		action = wezterm.action_callback(function(window, _)
			local overrides = window:get_config_overrides() or {}
			if overrides.window_background_opacity == 1.0 then
				overrides.window_background_opacity = 0.9
			else
				overrides.window_background_opacity = 1.0
			end
			window:set_config_overrides(overrides)
		end),
	},
}

-- and finally, return the configuration to wezterm
return config
