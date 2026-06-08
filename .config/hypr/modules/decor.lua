hl.config({
	general = {
		border_size = 0,
		gaps_in = 3,
		gaps_out = 6,
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
			enabled = true,
			range = 16,
			render_power = 10,
			color = "#000000",
			color_inactive = "#000000",
		},

		blur = {
			enabled = true,
			size = 4,
			ignore_opacity = true,
			passes = 4,
		},
	},
})
