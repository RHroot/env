hl.config({
	ecosystem = {
		no_update_news = true,
	},
})

hl.config({
	xwayland = {
		enabled = true, --- Enable XWayland
		force_zero_scaling = false, --- Force zero scaling
	},
})

hl.config({
	binds = {
		workspace_back_and_forth = true, --- Workspace back and forth
		allow_workspace_cycles = true, --- Allow workspace cycles
		pass_mouse_when_bound = true, --- Pass mouse when bound
	},
})

hl.config({
	cursor = {
		sync_gsettings_theme = true, --- Sync with GSettings theme
		no_hardware_cursors = false, --- Enable hardware cursors
		enable_hyprcursor = true, --- Enable Hyprland cursor
		warp_on_change_workspace = 0, --- Warp cursor on workspace change
		no_warps = true, --- Disable cursor warps
	},
})

hl.config({
	general = {
		allow_tearing = true, --- Allow tearing
		resize_on_border = true, --- Resize windows by dragging borders
		layout = "master", --- Default layout
	},
	dwindle = {
		preserve_split = true, --- Preserve split direction
		special_scale_factor = 0.8, --- Scale factor for special workspaces
	},
	master = {
		new_status = "master", --- New windows become master
		new_on_top = 1, --- New windows appear on top
		mfact = 0.51, --- Master area factor (51%)
	},
})

hl.gesture({
	-- gesture = "3, horizontal, workspace",
	fingers = 3,
	direction = "horizontal",
	action = "workspace",
	workspace_swipe_distance = 600, --- Swipe distance
	workspace_swipe_invert = true, --- Invert swipe direction
	workspace_swipe_min_speed_to_force = 30, --- Minimum speed to force
	workspace_swipe_cancel_ratio = 0.5, --- Cancel ratio
	workspace_swipe_create_new = true, --- Create new workspace on swipe
	workspace_swipe_forever = true, --- Infinite workspace swipe
})

hl.config({
	misc = {
		vrr = 0, --- Variable refresh rate
		disable_hyprland_logo = true, --- Show Hyprland logo
		disable_splash_rendering = true, --- Disable splash screen
		mouse_move_enables_dpms = true, --- Enable DPMS on mouse move
		enable_swallow = false, --- Window swallowing
		swallow_regex = "^(kitty|alacritty)$",
		focus_on_activate = false, --- Focus on window activation
		animate_manual_resizes = false, --- Don't animate manual resizes
		animate_mouse_windowdragging = false, --- Don't animate window dragging
		middle_click_paste = false, --- Middle click paste
	},
})

hl.config({
	input = {
		kb_layout = "us", --- Keyboard layout
		kb_variant = "", --- Keyboard variant
		kb_model = "", --- Keyboard model
		kb_options = "", --- Keyboard options
		kb_rules = "", --- Keyboard rules
		repeat_rate = 50, --- Key repeat rate
		repeat_delay = 200, --- Key repeat delay
		sensitivity = 0, --- Mouse sensitivity
		numlock_by_default = false, --- Enable numlock by default
		left_handed = false, --- Left-handed mouse
		follow_mouse = 1, --- Focus follows mouse
		mouse_refocus = false,
		float_switch_override_focus = true, --- Focus override for floating windows
		--- Touchpad configuration
		touchpad = {
			disable_while_typing = true, --- Disable touchpad while typing
			natural_scroll = false, --- Natural scrolling
			clickfinger_behavior = true, --- Click finger behavior
			middle_button_emulation = true, --- Middle button emulation
			drag_lock = true, --- Drag lock
		},
		--- Touch device configuration
		touchdevice = {
			enabled = true, --- Enable touch devices
		},
		--- Tablet configuration
		tablet = {
			transform = 0, --- Tablet transform
			left_handed = 0, --- Left-handed tablet
		},
	},
})
