--- Floating Window Rules
hl.window_rule({
	match = { title = "^(Open|Save|Select|Choose|Upload)(.*)$" },
	float = true,
	size = { "monitor_w * 1.0", "monitor_h * 0.8" },
	move = { 0, 0 },
})
hl.window_rule({
	match = {
		class = "^(nm-connection-editor|.blueman-manager-wrapped|org.pulseaudio.pavucontrol|xdg-desktop-portal-gtk)$",
	},
	float = true,
	size = { "monitor_w * 1.0", "monitor_h * 0.8" },
	move = { 0, 0 },
})
hl.window_rule({
	match = { title = "^(Authentication Required|Unlock|Polkit|Authorize)(.*)$" },
	float = true,
	size = { "monitor_w * 1.0", "monitor_h * 0.8" },
	move = { 0, 0 },
})
hl.window_rule({
	match = { title = "^(Preferences|Settings|Properties|Configure)(.*)$" },
	float = true,
	size = { "monitor_w * 1.0", "monitor_h * 0.8" },
	move = { 0, 0 },
})

--- Workdspace-Window Rules
hl.window_rule({
	match = { class = "^(JetBrains-Toolbox)$" },
	workspace = 4,
})
hl.window_rule({
	match = { class = "^(vlc)$" },
	workspace = 5,
})
hl.window_rule({
	match = { class = "^(mpv)$" },
	workspace = 5,
})
hl.window_rule({
	match = { class = "^cs2$" },
	workspace = 7,
})
hl.window_rule({
	match = { class = "^steam_app.*" },
	workspace = 7,
})
hl.window_rule({
	match = { class = "^(steam)$" },
	workspace = 8,
})
hl.window_rule({
	match = { class = "^(org.telegram.desktop)$" },
	workspace = 9,
})
hl.window_rule({
	match = { class = "^(libreoffice-startcenter)$" },
	workspace = 8,
})
