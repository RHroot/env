--- Wayland & session
hl.env("XDG_CURRENT_DESKTOP", "Hyprland") -- Tells desktop portals (XDG) you are running Hyprland
hl.env("XDG_SESSION_DESKTOP", "Hyprland") -- Identifies the current desktop session name
hl.env("XDG_SESSION_TYPE", "wayland") -- Forces apps to treat the active session as Wayland

--- Electron & Chromium Apps
hl.env("NIXOS_OZONE_WL", "1") -- Forces NixOS-packaged Electron/Chromium apps to use native Wayland
hl.env("ELECTRON_OZONE_PLATFORM_HINT", "wayland") -- Hints Electron apps to run natively on Wayland instead of XWayland

--- Firefox / Mozilla (Gecko)
hl.env("MOZ_ENABLE_WAYLAND", "1") -- Forces Firefox to run natively on Wayland
hl.env("MOZ_WAYLAND_USE_VAAPI", "1") -- Enables VA-API hardware video acceleration in Firefox
hl.env("MOZ_DBUS_REMOTE", "1") -- Allows controlling existing Firefox instances via DBus
hl.env("MOZ_USE_XINPUT2", "1") -- Enables smooth touchpad scrolling and high-precision input events

--- Toolkit Backends
hl.env("GDK_BACKEND", "wayland") -- Forces GTK3/GTK4 applications to use Wayland
hl.env("QT_QPA_PLATFORM", "wayland;xcb") -- Tells Qt apps to prefer Wayland, falling back to XWayland if needed
hl.env("QT_WAYLAND_DISABLE_WINDOWDECORATION", "1") -- Disables server-side window decorations for Qt apps
hl.env("CLUTTER_BACKEND", "wayland") -- Forces Clutter-based applications to use Wayland

--- Java
hl.env("_JAVA_AWT_WM_NONREPARENTING", "1") -- Fixes blank/gray window issues in Java GUI apps under tiling WM

--- Hardware Acceleration & Intel VA-API
hl.env("LIBVA_DRIVER_NAME", "iHD") -- Forces Intel's modern iHD driver for VA-API video decoding
hl.env("WLR_DRM_NO_ATOMIC", "0") -- Enables atomic KMS modesetting (smooth rendering on supported GPUs)

--- Cursor Settings
hl.env("HYPRCURSOR_THEME", "Bibata-Modern-Ice") -- Sets cursor theme for modern Hyprland-native apps
hl.env("HYPRCURSOR_SIZE", "30") -- Sets cursor size for Hyprland-native apps
hl.env("XCURSOR_THEME", "Bibata-Modern-Ice") -- Sets legacy X11/XWayland cursor theme fallback
hl.env("XCURSOR_SIZE", "30") -- Sets legacy X11/XWayland cursor size fallback

--- NVIDIA offloading (pick only if you want NVIDIA to render)
-- hl.env("__NV_PRIME_RENDER_OFFLOAD", "1")
-- hl.env("__GLX_VENDOR_LIBRARY_NAME", "nvidia")
-- hl.env("__GL_GSYNC_ALLOWED", "0")
-- hl.env("__GL_VRR_ALLOWED", "0")
