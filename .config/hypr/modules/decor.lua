hl.config({
	general = {
		gaps_in = 1,
		gaps_out = 3,
		border_size = 3,
		allow_tearing = false,
		resize_on_border = false,
		col = {
			active_border = {
				colors = {
					"rgba(6f0000ff)",
					"rgba(9a0000ff)",
				},
				angle = 45,
			},
			inactive_border = {
				colors = {
					"rgba(2a2a2aff)",
				},
			},
		},
	},
})

hl.config({
	decoration = {
		rounding = 16,

		active_opacity = 0.95,
		inactive_opacity = 0.7,
		fullscreen_opacity = 1.0,
		dim_inactive = false,

		shadow = {
			enabled = false,
		},

		blur = {
			enabled = true,
			size = 2,
			ignore_opacity = true,
			passes = 2,
		},
	},
})
