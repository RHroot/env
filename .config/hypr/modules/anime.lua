hl.config({
	animations = {
		enabled = false,
	},
})

--- Curves
local curves = {
	smoothOut = { { 0.25, 0.9 }, { 0.35, 1.0 } },
	smoothInOut = { { 0.4, 0.0 }, { 0.2, 1.0 } },
	subtle = { { 0.22, 0.9 }, { 0.3, 1.0 } },
	stylish = { { 0.2, 1.0 }, { 0.15, 1.0 } },
}

for name, pts in pairs(curves) do
	hl.curve(name, { type = "bezier", points = pts })
end

--- Animations
local anims = {
	{ leaf = "windows", bezier = "stylish", style = "popin 96%" },
	{ leaf = "windowsOut", bezier = "smoothInOut", style = "popin 96%" },
	{ leaf = "border", bezier = "subtle" },
	{ leaf = "fade", bezier = "smoothInOut" },
	{ leaf = "layersIn", bezier = "subtle", style = "slide bottom" },
	{ leaf = "layersOut", bezier = "smoothInOut", style = "slide bottom" },
	{ leaf = "fadeLayersIn", bezier = "subtle" },
	{ leaf = "fadeLayersOut", bezier = "smoothInOut" },
	{ leaf = "workspaces", bezier = "stylish", style = "slide" },
}

for _, a in ipairs(anims) do
	a.enabled, a.speed = true, 1
	hl.animation(a)
end
