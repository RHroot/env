--- Floating Window Rules
local function float_dialog(match)
	hl.window_rule({
		match = match,
		float = true,
		size = { "monitor_w", "monitor_h * 0.8" },
		move = { 0, 0 },
	})
end

float_dialog({
	initial_title = [[^(Open|Save|Select|Choose|Upload|Authentication Required|Unlock|Polkit|Authorize|Preferences|Settings|Properties|Configure)(.*)$]],
})

float_dialog({
	class = [[^(nm-connection-editor|\.blueman-manager-wrapped|org\.pulseaudio\.pavucontrol|xdg-desktop-portal-gtk)$]],
})

--- Workspace-Window Rules
hl.window_rule({
	match = { class = "^(vlc)$" },
	workspace = "5",
	fullscreen = true,
})

hl.window_rule({
	match = { class = "^(mpv)$" },
	workspace = "5",
	fullscreen = true,
})

hl.window_rule({
	match = { class = "^cs2$" },
	workspace = "7 silent",
	fullscreen = true,
})

hl.window_rule({
	match = { class = "^steam_app.*" },
	workspace = "7 silent",
	fullscreen = true,
})

hl.window_rule({
	match = { initial_title = "Brawlhalla" },
	workspace = "7 silent",
	fullscreen = true,
})

hl.window_rule({
	match = { class = "^(steam)$" },
	workspace = "8 silent",
	center = true,
})

hl.window_rule({
	match = { title = "^(Steam)(.*)$" },
	workspace = "8 silent",
	center = true,
})

hl.window_rule({
	match = { class = "^(heroic)$" },
	workspace = "8 silent",
	center = true,
})

hl.window_rule({
	match = { class = "^(org.telegram.desktop)$" },
	workspace = "9 silent",
})

hl.window_rule({
	match = { class = "^(libreoffice-startcenter)$" },
	workspace = "6 silent",
})
