hl.config({
	animations = {
		enabled = false,
	},
})

-- Define Bezier Curves
hl.curve("smoothOut", { type = "bezier", points = { { 0.25, 0.9 }, { 0.35, 1.0 } } })
hl.curve("smoothInOut", { type = "bezier", points = { { 0.4, 0.0 }, { 0.2, 1.0 } } })
hl.curve("subtle", { type = "bezier", points = { { 0.22, 0.9 }, { 0.3, 1.0 } } })
hl.curve("stylish", { type = "bezier", points = { { 0.2, 1.0 }, { 0.15, 1.0 } } })

-- Define Animations
hl.animation({ leaf = "windows", enabled = true, speed = 1, bezier = "stylish", style = "popin 96%" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 1, bezier = "smoothInOut", style = "popin 96%" })
hl.animation({ leaf = "border", enabled = true, speed = 1, bezier = "subtle" })
hl.animation({ leaf = "fade", enabled = true, speed = 1, bezier = "smoothInOut" })
hl.animation({ leaf = "layersIn", enabled = true, speed = 1, bezier = "subtle", style = "slide bottom" })
hl.animation({ leaf = "layersOut", enabled = true, speed = 1, bezier = "smoothInOut", style = "slide bottom" })
hl.animation({ leaf = "fadeLayersIn", enabled = true, speed = 1, bezier = "subtle" })
hl.animation({ leaf = "fadeLayersOut", enabled = true, speed = 1, bezier = "smoothInOut" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 1, bezier = "stylish", style = "slide" })
