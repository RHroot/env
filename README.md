# <img src="refrence/logo.png" alt="Logo" width="80" align="center"> My NixOS Dotfiles

This repository contains my personal dotfiles and system configurations for my NixOS setup. It provides a modular, multi-desktop environment (Hyprland, Qtile, XFCE) powered by Nix Flakes, custom utility scripts, dynamic color theming, and system-level performance optimizations.

## ⚙️ System Overview

| Component                        | Details                                                                                                                                                            |
| -------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| **❄️ Operating System**          | [NixOS](https://nixos.org/) 26.05 with Flakes (Hybrid Stable Base + Unstable Overlays)                                                                             |
| **🪟 Window & Desktop Managers** | [Hyprland](https://hyprland.org/) (Wayland), [Qtile](https://qtile.org/) (X11), and [XFCE](https://xfce.org/) (Desktop Environment)                                |
| **📊 Status Bar & Widgets**      | [Eww](https://github.com/elkowar/eww) custom `hyprbar` widget with system metrics, workspace indicator & [Hyprsunset](https://github.com/hyprwm/hyprsunset) toggle |
| **🔒 Idle & Lock Screen**        | [Hypridle](https://github.com/hyprwm/hypridle) and [Hyprlock](https://github.com/hyprwm/hyprlock)                                                                  |
| **💻 Terminals**                 | [Alacritty](https://alacritty.org/) & [Kitty](https://sw.kovidgoyal.net/kitty/)                                                                                    |
| **🐚 Shell Environment**         | [Fish](https://fishshell.com/) with [Starship](https://starship.rs/) prompt, [Zoxide](https://github.com/ajeetdsouza/zoxide) navigation & custom functions         |
| **✏️ Text Editors**              | [Neovim](https://neovim.io/), [Zed Editor](https://zed.dev/), [Neovide](https://neovide.dev/), and Vim (Unstable)                                                  |
| **🎨 Dynamic Theming**           | [Matugen](https://github.com/InioX/matugen) wallpaper palette generator, GTK (Flat-Remix-GTK-Magenta-Darkest), Papirus-Dark icons, Bibata cursors                  |
| **🚀 App Launcher & Menus**      | [Rofi](https://github.com/davatorium/rofi) with custom powermenu, bluetooth (`bluerofi`), clipboard (`rofi-copyq`), and icon picker                                |
| **🔔 Notifications**             | [Dunst](https://dunst-project.org/)                                                                                                                                |
| **📋 Clipboard Management**      | `wl-clipboard`, `cliphist` & `copyq`                                                                                                                               |
| **🔊 Audio Architecture**        | [PipeWire](https://pipewire.org/) with WirePlumber (quantum-locked to 512, Intel PCH priority tuning)                                                              |
| **🎮 Gaming Support**            | Steam (Proton-GE), Lutris, GameMode, Gamescope, MangoHud & Wine WOW64                                                                                              |
| **🖥️ GPU & Graphics**            | NVIDIA PRIME Offload (Quadro P2000 Mobile + Intel iGPU UHD 630), VAAPI hardware acceleration & custom `gpu-check` tool                                             |
| **🔋 Battery & Power**           | Dynamic charge start/stop thresholds (80% battery threshold), `batsignal` battery warnings & `power-profiles-daemon`                                               |
| **🛡️ Network & Privacy**         | DNS-over-TLS (Cloudflare & Quad9), Fail2ban, Brave Browser with enterprise debloating policies & ProtonVPN                                                         |
| **📦 Dotfile Manager**           | [GNU Stow](https://www.gnu.org/software/stow/)                                                                                                                     |

---

## 📂 Repository Structure

The repository is organized as follows:

### ⚙️ Core NixOS System (`nixos/`)

- **`nixos/configuration.nix`**: Main system configuration entry point (hostname `rhroot`, user `sten`).
- **`nixos/foundation/`**: Essential infrastructure layer:
  - `base.nix`: Core CLI packages (`btop`, `stow`, `dust`, `fastfetch`, `tealdeer`, `aria2`, `bat`), `nix-ld`, and `nix-index`.
  - `git.nix`: Git setup, Delta diff pager integration, and SSH commit signing.
  - `network.nix`: DNS-over-TLS (`systemd-resolved` with Cloudflare & Quad9), Fail2ban, Firewall rules, and ProtonVPN.
  - `power.nix`: Battery charge threshold management (80% charge limit), `batsignal` daemon, and `power-profiles-daemon`.
  - `shell.nix`: Fish & Starship system configuration, global Bash aliases, Kali-like prompt fallback, and environment variables.
  - `default.nix`: Foundation module aggregator.
- **`nixos/modules/`**: Modular feature layers:
  - `audio.nix`: PipeWire audio engine, forced 512 quantum latency, and ALSA node priority (Intel PCH over NVIDIA).
  - `content.nix`: Media production software (`GIMP`, `Audacity`, `OBS Studio`, `Kdenlive`).
  - `gaming.nix`: Steam with Proton-GE, Lutris, GameMode, Gamescope, MangoHud, and Wine.
  - `graphics.nix`: NVIDIA PRIME offload (Quadro P2000 + Intel iGPU UHD 630), VAAPI acceleration, OpenCL, Vulkan, and custom `gpu-check` diagnostic script.
  - `theming.nix`: GTK 2/3/4 themes, Papirus-Dark icons, Bibata-Modern-Ice cursors, and custom font definitions (FiraCode Nerd Font, Noto Sans, Merriweather).
  - `toolbox.nix`: Developer tools and runtimes (Python 3.13 + `uv`, Node.js + `bun`, C/C++ GCC/Clang/CMake, Rust, Lua, Neovim, Zed Editor, Eww, Nmap, TCPDump, Strace).
  - `utility.nix`: Desktop productivity applications (Brave Browser with debloating policies, MPV, Evince, Zotero, Foliate, Blanket, qBittorrent, Telegram).
  - `default.nix`: Feature module aggregator.
- **`nixos/hyprland/`**: Hyprland window manager system integration (`default.nix`, `wset`, `wset-backend`).
- **`nixos/qtile/`**: Qtile window manager system integration (`default.nix`, `wset`, `wset-backend`).
- **`nixos/XFCE/`**: XFCE desktop environment configuration (`default.nix` with LightDM/Ly, xrandr, Wacom driver).
- **`flake.nix` & `flake.lock`**: Nix Flake declaration using NixOS 26.05 stable base with `nixos-unstable` overlays.

---

### 🎨 Application Configurations (`.config/`)

- **`hypr/`**: Modular Lua-based Hyprland window manager configuration:
  - `hyprland.lua`: Main Lua entry point.
  - `modules/`: Feature-specific modules (`keys.lua`, `setts.lua`, `decor.lua`, `evars.lua`, `wrules.lua`, `start.lua`, `res.lua`, `anime.lua`, `hyprland-colors.lua`).
  - `hyprlock.conf` & `hypridle.conf`: Lock screen and idle management.
- **`eww/`**: ElKowar's Wacky Widgets status bar configuration:
  - `eww.yuck` & `eww.css`: Custom `hyprbar` widget displaying CPU, RAM, Disk, Audio, Brightness, Battery, Workspaces, and Systray.
  - `hyprnight.sh`: Toggle script for Hyprsunset blue-light reduction.
  - `get-workspaces.sh`: Dynamic Hyprland workspace fetcher.
- **`fish/`**: Custom Fish shell configuration:
  - `config.fish`, `conf.d/` (`05-zoxide`, `10-starship`, `20-env`, `30-abbreviations`, `40-keybinds`, `fish_frozen_key_bindings`).
  - `functions/`: Custom helper functions (`gc`, `gac`, `gacp`, `nix-clean`, `git-clean`, `nix-fish`, `hyprctl`, `view`).
  - `completions/`: GitHub Copilot CLI completion script.
- **`alacritty/`**: Alacritty GPU terminal configuration (`alacritty.toml`).
- **`kitty/`**: Kitty terminal configuration (`kitty.conf`).
- **`rofi/`**: Rofi menu launcher, power menu (`powermenu.rasi`), art selector (`art_selector.rasi`), and icon picker database (`icons.csv`).
- **`mpv/`**: MPV video player configuration (`mpv.conf` with Vulkan GPU-next renderer, debanding filters, and high-contrast yellow subtitles).
- **`zed/`**: Zed editor settings (`settings.json` with Catppuccin Espresso theme and FiraCode Nerd Font).
- **`matugen/`**: Material You color theme generator config and templates (`starship`, `gtk.css`, `colors.rasi`, `colors.conf`, `colors.css`, `dunstrc`).
- **`picom/`**: Picom compositor configuration for X11 sessions (`picom.conf`).
- **`qtile/`**: Qtile python configuration (`config.py`, `autostart`).
- **`tealdeer/`**: Tealdeer (tldr) configuration (`config.toml`).
- **`aria2/`**: Aria2 download manager settings (`aria2.conf`).
- **`libinput-gestures.conf`**: Custom 3-finger and 4-finger touchpad gesture mappings linked to `xdotool`.

---

### 🛠️ Helper Scripts & Custom Executables (`.local/`)

- **`.local/bin/`**:
  - `rebuild`: Custom NixOS system rebuild helper with colored stage output and log parsing.
  - `uprebuild`: Automatic flake input updater, git commit sync, system rebuild, and store optimizer.
  - `cwifi`: Interactive CLI tool for WiFi network management.
  - `gpu-check`: Comprehensive diagnostic script for verifying NVIDIA PRIME offload, Vulkan adapters, and VAAPI hardware decoding.
  - `bluerofi`: Rofi-based Bluetooth management menu.
  - `rofi-copyq`: Rofi clipboard history search menu.
  - `powermenu`: Rofi system power options menu.
  - `icon_picker`: Rofi icon search and copy tool.
  - `setup-git` & `multi_git_setup`: Single and multi-account Git workspace setup tools.
  - `stickers`: Asset management script.
  - `age`: Encryption helper script.
- **`.local/share/fastfetch/presets/my.jsonc`**: Custom system summary layout for `fastfetch`.

---

### 📚 Technical Reference Library (`refrence/`)

- **`d_s.md`**: Step-by-step guide for fetching and serving local GGUF LLMs (`Qwen2.5`) via `huggingface-hub` and `llama.cpp` CUDA backend.
- **`git_guide.md`**: Detailed Git command notes, subtrees, and workflow patterns.
- **`git_multi_account_setup.txt`**: Guide for managing multiple SSH keys and Git user configurations.
- **`substitution-regex-guide.md`**: Guide to regular expressions, capture groups, and substitution patterns.
- **`systemd_guide.md`**: Reference guide for managing Systemd services, units, and timers.
- **`xargs-guide.md`**: Guide for parallel processing and command chaining using `xargs`.
- **`TIGER_STYLE.md`**: Software development philosophy focusing on safety, assertion density, and performance.
- **`useful_commands.md`**: Quick reference cheat sheet for Linux hardware, kernel, network, and storage diagnostics.
- **`animestowatch.txt`**: Anime watchlist notes.
- **`bookmarks.html`**: Curated web bookmarks collection.
- **`logo.png`**: Repository header logo image.

---

## 🚀 Usage & Maintenance

### 1. Installation & Dotfiles Symlinking

This repository uses [GNU Stow](https://www.gnu.org/software/stow/) to symlink application configurations into `$HOME`.

```bash
# Clone the repository
git clone --depth 1 https://github.com/RHroot/env.git ~/env
cd ~/env

# Symlink all dotfiles to home directory
stow .
```

### 2. Rebuilding the System

Use the custom rebuild helper script to apply configuration changes with formatted output:

```bash
# Standard system rebuild
rebuild
```

_(Equivalent to `sudo nixos-rebuild switch --impure --flake .#rhroot`)_

### 3. Upgrading System & Dependencies

To update flake lockfiles, rebuild the system, and optimize the Nix store in one step:

```bash
# Upgrade system inputs, commit changes, rebuild & optimize store
uprebuild
```

### 4. GPU Diagnostics

To verify NVIDIA PRIME offload, Vulkan rendering, and VAAPI hardware acceleration:

```bash
gpu-check
```

---

## ✨ Key Features

- **🔄 Hybrid Flakes Architecture**: Combines NixOS 26.05 stable system packages with cutting-edge unstable package overlays.
- **🖥️ Multi-Desktop Environment**: Supports Hyprland (Wayland), Qtile (X11), and XFCE desktop sessions.
- **🎯 Custom Hyprland Architecture**: Modular Lua configuration split into clean, single-responsibility files (`keys`, `setts`, `decor`, `evars`, `wrules`, `start`, `res`, `anime`, `hyprland-colors`).
- **📊 Integrated Eww Status Bar**: Feature-rich status bar showing CPU, RAM, Disk usage, PipeWire Audio level, Display Brightness, Battery status, Workspaces, Systray, and Hyprnight blue-light toggle.
- **🎨 Wallpaper-Driven Theme Engine**: Matugen dynamically extracts color schemes from wallpapers and applies them across Alacritty, Kitty, Rofi, Dunst, and Hyprland.
- **⚡ Hardened Graphics & Audio Performance**:
  - NVIDIA Quadro P2000 PRIME offload with automatic D3cold idle power-saving.
  - PipeWire audio engine locked to 512 quantum size with ALSA node priority favoring Intel PCH audio.
  - Custom MPV profile utilizing Vulkan API, `gpu-next` video output, debanding filters, and crisp yellow subtitles.
- **🔋 Battery Preservation**: Automated dynamic threshold service capping battery charge at 80% to maximize long-term battery lifespan.
- **🛡️ Enterprise Privacy Settings**: Custom Brave browser policy enforcing zero telemetry, disabling AI chat, rewards, wallet, and background analytics, paired with system-wide DNS-over-TLS (Cloudflare & Quad9).
- **🤖 Local LLM Support**: Built-in instructions and scripts for running GGUF LLMs via CUDA acceleration with `llama.cpp`.

---

## 📚 Technical Guides

You can view detailed documentation in the `refrence/` directory:

- [Local LLM Guide (`refrence/d_s.md`)](./refrence/d_s.md)
- [Linux Diagnostic Commands (`refrence/useful_commands.md`)](./refrence/useful_commands.md)
- [Git Guide (`refrence/git_guide.md`)](./refrence/git_guide.md)
- [Multi-Account Git Setup (`refrence/git_multi_account_setup.txt`)](./refrence/git_multi_account_setup.txt)
- [Systemd Reference (`refrence/systemd_guide.md`)](./refrence/systemd_guide.md)
- [Regex & Substitution Guide (`refrence/substitution-regex-guide.md`)](./refrence/substitution-regex-guide.md)
- [xargs Mastery Guide (`refrence/xargs-guide.md`)](./refrence/xargs-guide.md)
- [Tiger Style Engineering (`refrence/TIGER_STYLE.md`)](./refrence/TIGER_STYLE.md)

---

## 📜 License

This repository is licensed under the [MIT License](LICENSE).
