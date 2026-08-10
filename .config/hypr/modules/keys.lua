---            VARIABLE DEFINITIONS
local opts = { repeating = true }
local terminal = "kitty"
local filemanager = "nautilus"
local alt_terminal = "alacritty"
local runmenu = "rofi -show run"
-- local browser = "firefox -P 'Default'"
-- local alt_browser = "firefox -P 'Work'"
local theme = "$HOME/env/nixos/hyprland/wset"
local browser = "brave --profile-directory='Default'"
local alt_browser = "brave --profile-directory='Work'"
local vanishing_terminal = "kitten quick-access-terminal"
local menu = "rofi -show combi -modes combi -combi-modes 'window,drun,run'"
local clipboardmanager = "cliphist list | rofi -dmenu -p 'Clipboard' -theme config | cliphist decode | wl-copy"

---           APPLICATION LAUNCHERS
hl.bind("SUPER + R", hl.dsp.exec_cmd(runmenu))
hl.bind("SUPER + B", hl.dsp.exec_cmd(browser))
hl.bind("SUPER + SPACE", hl.dsp.exec_cmd(menu))
hl.bind("SUPER + E", hl.dsp.exec_cmd(filemanager))
hl.bind("SUPER + Return", hl.dsp.exec_cmd(terminal))
hl.bind("SUPER + SHIFT + W", hl.dsp.exec_cmd(theme))
hl.bind("SUPER  + V", hl.dsp.exec_cmd(clipboardmanager))
hl.bind("SUPER + P ", hl.dsp.exec_cmd(vanishing_terminal))
hl.bind("SUPER + SHIFT + B", hl.dsp.exec_cmd(alt_browser))
hl.bind("SUPER + SHIFT + V", hl.dsp.exec_cmd("pavucontrol"))
hl.bind("SUPER + SHIFT + E", hl.dsp.exec_cmd("emacsclient -c"))
hl.bind("SUPER + SHIFT + Return", hl.dsp.exec_cmd(alt_terminal))

---           SYSTEM CONTROLS
-- --- System power and session management
hl.bind("SUPER + Escape", hl.dsp.exec_cmd("powermenu"))
hl.bind("CTRL + ALT + L", hl.dsp.exec_cmd("hyprlock"))
hl.bind("CTRL + ALT + R", hl.dsp.exec_cmd("systemctl reboot"))
hl.bind("CTRL + ALT + S", hl.dsp.exec_cmd("systemctl poweroff"))
hl.bind("CTRL + ALT + Q", hl.dsp.exit())

---           WINDOW MANAGEMENT
--- Window control and manipulation
hl.bind("SUPER + Q", hl.dsp.window.close())
hl.bind("SUPER + F", hl.dsp.window.fullscreen())
hl.bind("SUPER + SHIFT + F", hl.dsp.window.float())

---           Hyprshot keybinds
hl.bind("SUPER + PRINT", hl.dsp.exec_cmd("hyprshot -m output --clipboard-only"))
hl.bind("CTRL + PRINT", hl.dsp.exec_cmd("hyprshot -m region --clipboard-only"))
hl.bind("SHIFT + PRINT", hl.dsp.exec_cmd("hyprshot -m output -o $HOME/Screenshots"))
hl.bind("CTRL + SHIFT + PRINT", hl.dsp.exec_cmd("hyprshot -m region -o $HOME/Screenshots"))

--- Utility scripts
hl.bind("SUPER" .. " + SHIFT + R", hl.dsp.exec_cmd("hyprctl reload"))

---           WORKSPACE NAVIGATION
--- Workspace switching
hl.bind("SUPER + J", hl.dsp.focus({ workspace = "-1" }), opts)
hl.bind("SUPER + K", hl.dsp.focus({ workspace = "+1" }), opts)
hl.bind("SUPER + left", hl.dsp.focus({ workspace = "-1" }), opts)
hl.bind("SUPER + right", hl.dsp.focus({ workspace = "+1" }), opts)
hl.bind("SUPER + SHIFT + bracketleft", hl.dsp.focus({ workspace = "m-1" }), opts)
hl.bind("SUPER + SHIFT + bracketright", hl.dsp.focus({ workspace = "m+1" }), opts)

local directions = {
	{ key = "j", dir = "d" },
	{ key = "k", dir = "u" },
	{ key = "h", dir = "l" },
	{ key = "l", dir = "r" },
}

-- Focus movement
for _, d in ipairs(directions) do
	hl.bind("ALT + " .. d.key, hl.dsp.focus({ direction = d.dir }), opts)
	hl.bind("SUPER + ALT + " .. d.key, hl.dsp.window.swap({ direction = d.dir }), opts)
end

---           WORKSPACE NUMBERS
-- Key codes for 1-0 keys (assuming standard keyboard layout)
local key_codes = { 10, 11, 12, 13, 14, 15, 16, 17, 18, 19 }

-- Focus workspaces
for i, code in ipairs(key_codes) do
	hl.bind("SUPER + code:" .. code, hl.dsp.focus({ workspace = i }), opts)
end

-- Move windows to workspaces
for i, code in ipairs(key_codes) do
	hl.bind("SUPER + SHIFT + code:" .. code, hl.dsp.window.move({ workspace = i }), opts)
end

---                    WINDOW MANAGEMENT
local resize_actions = {
	{ key = "J", mod = "ALT + SHIFT + ", x = 0, y = 50 },
	{ key = "K", mod = "ALT + SHIFT + ", x = 0, y = -50 },
	{ key = "H", mod = "ALT + SHIFT + ", x = -50, y = 0 },
	{ key = "L", mod = "ALT + SHIFT + ", x = 50, y = 0 },
	{ key = "down", mod = "ALT + SHIFT + ", x = 0, y = 50 },
	{ key = "up", mod = "ALT + SHIFT + ", x = 0, y = -50 },
	{ key = "left", mod = "ALT + SHIFT + ", x = -50, y = 0 },
	{ key = "right", mod = "ALT + SHIFT + ", x = 50, y = 0 },
}

for _, r in ipairs(resize_actions) do
	hl.bind(r.mod .. r.key, hl.dsp.window.resize({ x = r.x, y = r.y, relative = true, repeating = true }), opts)
end

hl.bind("ALT + Tab", function()
	hl.dispatch(hl.dsp.window.cycle_next())
	hl.dispatch(hl.dsp.window.bring_to_top())
end)

---           MOUSE BINDINGS
--- Mouse window management
hl.bind("SUPER + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind("SUPER + mouse:273", hl.dsp.window.resize(), { mouse = true })

---          LID SWITCH
--- Trigger when the switch is toggled.
hl.bind("switch:[switch name]", hl.dsp.exec_cmd("hyprlock"), { locked = true })

---           BRIGHTNESS CONTROLS
hl.bind(
	"XF86MonBrightnessUp",
	hl.dsp.exec_cmd(
		"sh -c 'brightnessctl set +10% >/dev/null; level=$(brightnessctl -m | cut -d, -f4 | tr -d %); notify-send \"Brightness: $level%\"'"
	),
	{ locked = true, repeating = true }
)
hl.bind(
	"XF86MonBrightnessDown",
	hl.dsp.exec_cmd(
		"sh -c 'brightnessctl set 10%- >/dev/null; level=$(brightnessctl -m | cut -d, -f4 | tr -d %); notify-send \"Brightness: $level%\"'"
	),
	{ locked = true, repeating = true }
)

---           AUDIO CONTROLS
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioStop", hl.dsp.exec_cmd("playerctl stop"), { locked = true })
hl.bind(
	"XF86AudioRaiseVolume",
	hl.dsp.exec_cmd(
		'sh -c \'wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.05+ >/dev/null; level=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | cut -d" " -f2 | tr -d . | sed "s/^0*//"); notify-send "Volume: ${level:-0}%"\''
	),
	{ repeating = true }
)
hl.bind(
	"XF86AudioLowerVolume",
	hl.dsp.exec_cmd(
		'sh -c \'wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.05- >/dev/null; level=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | cut -d" " -f2 | tr -d . | sed "s/^0*//"); notify-send "Volume: ${level:-0}%"\''
	),
	{ repeating = true }
)
hl.bind(
	"XF86AudioMicMute",
	hl.dsp.exec_cmd(
		'sh -c \'current_mute=$(wpctl get-volume @DEFAULT_AUDIO_SOURCE@ | grep -o "MUTED"); if [ -n "$current_mute" ]; then wpctl set-mute @DEFAULT_AUDIO_SOURCE@ 0 && notify-send "Microphone" "🎤 Unmuted"; else wpctl set-mute @DEFAULT_AUDIO_SOURCE@ 1 && notify-send "Microphone" "🎙️ Muted"; fi\''
	)
)
hl.bind(
	"XF86AudioMute",
	hl.dsp.exec_cmd(
		'sh -c \'current_mute=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | grep -o "MUTED"); if [ -n "$current_mute" ]; then wpctl set-mute @DEFAULT_AUDIO_SINK@ 0 && notify-send "Volume" "🔊 Unmuted"; else wpctl set-mute @DEFAULT_AUDIO_SINK@ 1 && notify-send "Volume" "🔇 Muted"; fi\''
	)
)
