---            VARIABLE DEFINITIONS
local terminal = "kitty"
local filemanager = "nautilus"
local alt_terminal = "alacritty"
local runmenu = "rofi -show run"
local browser = "firefox -p default"
local alt_browser = "firefox -p Work"
local theme = "$HOME/env/nixos/hyprland/wset"
local vanishing_terminal = "kitten quick-access-terminal"
local clipboardmanager = "$HOME/env/nixos/hyprland/clipman"
local menu = "rofi -show combi -modes combi -combi-modes 'window,drun,run'"

---           APPLICATION LAUNCHERS
hl.bind("SUPER + Return", hl.dsp.exec_cmd(terminal))
hl.bind("SUPER + SHIFT + E", hl.dsp.exec_cmd("emacsclient -c"))
hl.bind("SUPER + P ", hl.dsp.exec_cmd(vanishing_terminal))
hl.bind("SUPER + SHIFT + Return", hl.dsp.exec_cmd(alt_terminal))
hl.bind("SUPER + SPACE", hl.dsp.exec_cmd(menu))
hl.bind("SUPER + R", hl.dsp.exec_cmd(runmenu))
hl.bind("ALT + SPACE", hl.dsp.exec_cmd(theme))
hl.bind("SUPER + B", hl.dsp.exec_cmd(browser))
hl.bind("SUPER + SHIFT + B", hl.dsp.exec_cmd(alt_browser))
hl.bind("SUPER + E", hl.dsp.exec_cmd(filemanager))
hl.bind("SUPER + SHIFT + V", hl.dsp.exec_cmd("pavucontrol"))
hl.bind("SUPER  + V", hl.dsp.exec_cmd(clipboardmanager))

---           SYSTEM CONTROLS
-- --- System power and session management
hl.bind("SUPER + Escape", hl.dsp.exec_cmd("powermenu"))
hl.bind("CTRL + ALT + L", hl.dsp.exec_cmd("hyprlock"))
hl.bind("CTRL + ALT + S", hl.dsp.exec_cmd("systemctl poweroff"))
hl.bind("CTRL + ALT + R", hl.dsp.exec_cmd("systemctl reboot"))
hl.bind("CTRL + ALT + Q", hl.dsp.exec_cmd("hyprctl dispatch exit 0"))

---           WINDOW MANAGEMENT
--- Window control and manipulation
hl.bind("SUPER + Q", hl.dsp.window.close())
hl.bind("SUPER + F", hl.dsp.window.fullscreen())
hl.bind("SUPER + SHIFT + F", hl.dsp.window.float())

---           Hyprshot keybinds
hl.bind("PRINT", hl.dsp.exec_cmd("hyprshot -m output --clipboard-only"))
hl.bind("CTRL + PRINT", hl.dsp.exec_cmd("hyprshot -m region --clipboard-only"))
hl.bind("SHIFT + PRINT", hl.dsp.exec_cmd("hyprshot -m output -o $HOME/Screenshots"))
hl.bind("CTRL + SHIFT + PRINT", hl.dsp.exec_cmd("hyprshot -m region -o $HOME/Screenshots"))

--- Utility scripts
hl.bind("SUPER" .. " + SHIFT + R", hl.dsp.exec_cmd("hyprctl reload"))

---           WORKSPACE NAVIGATION
--- Workspace switching
hl.bind("SUPER + J", hl.dsp.focus({ workspace = "-1" }))
hl.bind("SUPER + K", hl.dsp.focus({ workspace = "+1" }))
hl.bind("SUPER + left", hl.dsp.focus({ workspace = "-1" }))
hl.bind("SUPER + right", hl.dsp.focus({ workspace = "+1" }))
hl.bind("SUPER + SHIFT + bracketleft", hl.dsp.focus({ workspace = "m-1" }))
hl.bind("SUPER + SHIFT + bracketright", hl.dsp.focus({ workspace = "m+1" }))

--- Focus movement
hl.bind("ALT + j", hl.dsp.focus({ direction = "d" }))
hl.bind("ALT + k", hl.dsp.focus({ direction = "u" }))
hl.bind("ALT + h", hl.dsp.focus({ direction = "l" }))
hl.bind("ALT + l", hl.dsp.focus({ direction = "r" }))
hl.bind("SUPER + ALT + j", hl.dsp.window.swap({ direction = "d" }))
hl.bind("SUPER + ALT + k", hl.dsp.window.swap({ direction = "u" }))
hl.bind("SUPER + ALT + h", hl.dsp.window.swap({ direction = "l" }))
hl.bind("SUPER + ALT + l", hl.dsp.window.swap({ direction = "r" }))

---           WORKSPACE NUMBERS
hl.bind("SUPER + code:10", hl.dsp.focus({ workspace = 1 }))
hl.bind("SUPER + code:11", hl.dsp.focus({ workspace = 2 }))
hl.bind("SUPER + code:12", hl.dsp.focus({ workspace = 3 }))
hl.bind("SUPER + code:13", hl.dsp.focus({ workspace = 4 }))
hl.bind("SUPER + code:14", hl.dsp.focus({ workspace = 5 }))
hl.bind("SUPER + code:15", hl.dsp.focus({ workspace = 6 }))
hl.bind("SUPER + code:16", hl.dsp.focus({ workspace = 7 }))
hl.bind("SUPER + code:17", hl.dsp.focus({ workspace = 8 }))
hl.bind("SUPER + code:18", hl.dsp.focus({ workspace = 9 }))
hl.bind("SUPER + code:19", hl.dsp.focus({ workspace = 10 }))
hl.bind("SUPER + SHIFT + code:10", hl.dsp.window.move({ workspace = 1 }))
hl.bind("SUPER + SHIFT + code:11", hl.dsp.window.move({ workspace = 2 }))
hl.bind("SUPER + SHIFT + code:12", hl.dsp.window.move({ workspace = 3 }))
hl.bind("SUPER + SHIFT + code:13", hl.dsp.window.move({ workspace = 4 }))
hl.bind("SUPER + SHIFT + code:14", hl.dsp.window.move({ workspace = 5 }))
hl.bind("SUPER + SHIFT + code:15", hl.dsp.window.move({ workspace = 6 }))
hl.bind("SUPER + SHIFT + code:16", hl.dsp.window.move({ workspace = 7 }))
hl.bind("SUPER + SHIFT + code:17", hl.dsp.window.move({ workspace = 8 }))
hl.bind("SUPER + SHIFT + code:18", hl.dsp.window.move({ workspace = 9 }))
hl.bind("SUPER + SHIFT + code:19", hl.dsp.window.move({ workspace = 10 }))

---                    WINDOW MANAGEMENT
hl.bind("ALT + SHIFT + J", hl.dsp.window.resize({ x = 0, y = 50, relative = true, repeating = true }))
hl.bind("ALT + SHIFT + K", hl.dsp.window.resize({ x = 0, y = -50, relative = true, repeating = true }))
hl.bind("ALT + SHIFT + H", hl.dsp.window.resize({ x = -50, y = 0, relative = true, repeating = true }))
hl.bind("ALT + SHIFT + L", hl.dsp.window.resize({ x = 50, y = 0, relative = true, repeating = true }))
hl.bind("ALT + SHIFT + right", hl.dsp.window.resize({ x = 50, y = 0, relative = true, repeating = true }))
hl.bind("ALT + SHIFT + left", hl.dsp.window.resize({ x = -50, y = 0, relative = true, repeating = true }))
hl.bind("ALT + SHIFT + up", hl.dsp.window.resize({ x = 0, y = -50, relative = true, repeating = true }))
hl.bind("ALT + SHIFT + down", hl.dsp.window.resize({ x = 0, y = 50, relative = true, repeating = true }))
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
--- Trigger when the switch is turning on.
hl.bind("switch:on:[switch name]", hl.dsp.exec_cmd("notify-send 'yooo'"), { locked = true })
--- Trigger when the switch is turning off.
hl.bind("switch:off:[switch name]", hl.dsp.exec_cmd("notify-send 'among us'"), { locked = true })

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
hl.bind(
	"XF86MonBrightnessUp",
	hl.dsp.exec_cmd(
		"sh -c 'brightnessctl set +10% >/dev/null; level=$(brightnessctl -m | cut -d, -f4 | tr -d %); notify-send \"Brightness: $level%\"'"
	),
	{ locked = true }
)
hl.bind(
	"XF86MonBrightnessDown",
	hl.dsp.exec_cmd(
		"sh -c 'brightnessctl set 10%- >/dev/null; level=$(brightnessctl -m | cut -d, -f4 | tr -d %); notify-send \"Brightness: $level%\"'"
	),
	{ locked = true }
)
