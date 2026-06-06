local colors = require("modules.colors")

hl.config({
	group = {
		["col.border_active"] = colors.tertiary_container,
		groupbar = {
			["col.active"] = colors.tertiary,
		},
	},
})

hl.config({
	general = {
		border_size = 2,
		gaps_in = 2,
		gaps_out = 2,

		["col.active_border"] = colors.primary,
		["col.inactive_border"] = colors.surface_variant,
	},
})

hl.config({

	decoration = {
		rounding = 9,

		active_opacity = 0.9,
		inactive_opacity = 0.7,
		fullscreen_opacity = 1.0,
		dim_inactive = false,

		shadow = {
			enabled = true,
			range = 5,
			render_power = 4,
			color = colors.primary,
			color_inactive = "rgba(00000000)",
		},

		blur = {
			enabled = true,
			size = 1,
			ignore_opacity = true,
			passes = 2,
		},
	},
})
