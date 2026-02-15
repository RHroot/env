````md
# Waydroid Setup Guide (Post-Installation)

This guide assumes Waydroid is already installed and enabled on your system.
It covers:

- Clean initialization (vanilla)
- Initialization with GApps
- Starting & managing sessions
- Resolution and DPI tuning
- Useful performance tweaks

---

# 1. Clean Reset (Recommended Before Re-Init)

Always wipe previous state before switching images.

```bash
sudo systemctl stop waydroid-container
sudo rm -rf /var/lib/waydroid
```
````

---

# 2. Initialize Waydroid

## A. Vanilla (No Google Services)

```bash
sudo waydroid init
```

Start:

```bash
sudo systemctl start waydroid-container
waydroid session start
waydroid show-full-ui
```

Use this if:

- You don’t need Play Store
- You want a lighter system
- You install APKs manually

---

## B. With GApps (Play Store Included)

```bash
sudo waydroid init -s GAPPS
```

If needed:

```bash
sudo waydroid init -f -s GAPPS
```

Then start:

```bash
sudo systemctl start waydroid-container
waydroid session start
waydroid show-full-ui
```

After first boot:

- Open Play Store
- Sign in
- Let Play Services fully update before installing games

---

# 3. Session Management

Start session:

```bash
waydroid session start
```

Stop session:

```bash
waydroid session stop
```

Launch UI:

```bash
waydroid show-full-ui
```

Install APK:

```bash
waydroid app install file.apk
```

List apps:

```bash
waydroid app list
```

Open specific app:

```bash
waydroid app launch com.package.name
```

---

# 4. Display & Resolution Tuning

Waydroid uses Android’s window manager.

## Check Current Resolution

```bash
waydroid shell wm size
```

## Set Custom Resolution

Example 1280x720:

```bash
waydroid shell wm size 1280x720
```

Example 1920x1080:

```bash
waydroid shell wm size 1920x1080
```

## Reset to Default

```bash
waydroid shell wm size reset
```

---

# 5. DPI Scaling (Important for Games)

## Check Current DPI

```bash
waydroid shell wm density
```

## Set DPI (example 240)

```bash
waydroid shell wm density 240
```

Typical useful values:

- 200 → Larger UI
- 240 → Balanced
- 280–320 → More compact UI

## Reset

```bash
waydroid shell wm density reset
```

---

# 6. Performance Tweaks

Restart container cleanly:

```bash
waydroid session stop
sudo systemctl restart waydroid-container
waydroid session start
```

Check binder module:

```bash
lsmod | grep binder
```

Check logs if something fails:

```bash
waydroid log
```

---

# 7. Useful Android Shell Commands

Open Android shell:

```bash
waydroid shell
```

Inside shell you can:

Reboot Android:

```bash
reboot
```

Clear app cache:

```bash
pm clear com.package.name
```

Force stop app:

```bash
am force-stop com.package.name
```

---

# Recommended Setup Profile

If using for games:

- Initialize with `-s GAPPS`
- Set resolution to match your monitor (e.g., 1280x720 or 1920x1080)
- Set DPI to 240–280
- Let Play Services fully update before testing performance
