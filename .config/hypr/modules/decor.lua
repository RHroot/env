hl.config({
	general = {
		gaps_in = 1,
		gaps_out = 3,
		border_size = 2,
		allow_tearing = false,
		resize_on_border = false,
		col = {
			active_border = {
				colors = {
					"rgba(660000ff)", -- Dark Red
					"rgba(8b4500ff)", -- Dark Orange/Rust
					"rgba(666600ff)", -- Dark Yellow/Olive
					"rgba(004d00ff)", -- Dark Green
					"rgba(000066ff)", -- Dark Blue
					"rgba(330066ff)", -- Dark Purple
				},
				angle = 45,
			},
		},
	},
})

hl.config({
	decoration = {
		rounding = 16,

		active_opacity = 0.9,
		inactive_opacity = 0.5,
		fullscreen_opacity = 1.0,
		dim_inactive = false,

		shadow = {
			enabled = false,
		},

		blur = {
			enabled = true,
			size = 4,
			ignore_opacity = true,
			passes = 4,
		},
	},
})
