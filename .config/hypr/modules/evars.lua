--- Wayland & session
hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
hl.env("XDG_SESSION_DESKTOP", "Hyprland")
hl.env("XDG_SESSION_TYPE", "wayland")

--- Java fix
hl.env("_JAVA_AWT_WM_NONREPARENTING", "1")

--- Backend hints
hl.env("GDK_BACKEND", "wayland")
hl.env("QT_QPA_PLATFORM", "wayland;xcb")
hl.env("QT_WAYLAND_DISABLE_WINDOWDECORATION", "1")
hl.env("CLUTTER_BACKEND", "wayland")
hl.env("MOZ_ENABLE_WAYLAND", "1")
hl.env("ELECTRON_OZONE_PLATFORM_HINT", "wayland")

--- Intel VAAPI
hl.env("LIBVA_DRIVER_NAME", "iHD")
hl.env("WLR_DRM_NO_ATOMIC", ",0")

--- Cursor
hl.env("HYPRCURSOR_THEME", "Bibata-Modern-Ice")
hl.env("HYPRCURSOR_SIZE", "30")
hl.env("XCURSOR_THEME", "Bibata-Modern-Ice")
hl.env("XCURSOR_SIZE", "30")

--- NVIDIA offloading (pick only if you want NVIDIA to render)
-- hl.env("__NV_PRIME_RENDER_OFFLOAD", "1")
-- hl.env("__GLX_VENDOR_LIBRARY_NAME", "nvidia")
-- hl.env("__GL_GSYNC_ALLOWED", "0")
-- hl.env("__GL_VRR_ALLOWED", "0")
