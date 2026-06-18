# <img src="refrence/logo.png" alt="Logo" width="80" align="center"> My NixOS Dotfiles

This repository contains my personal dotfiles for my NixOS setup. It's a comprehensive configuration that includes everything from the operating system itself to my terminal, editor, and theming.

## ⚙️ System Overview

| Component                   | Details                                                                                                                                                    |
| --------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **❄️ Operating System**     | [NixOS](https://nixos.org/) 26.05 with Flakes                                                                                                            |
| **🪟 Window Manager**       | [Hyprland](https://hyprland.org/) with [Hypridle](https://github.com/hyprwm/hypridle), [Hyprlock](https://github.com/hyprwm/hyprlock), and [Hyprshot](https://github.com/Gustash/Hyprshot) |
| **💻 Terminal**             | [Alacritty](https://alacritty.org/) & [Kitty](https://sw.kovidgoyal.net/kitty/)                                                                        |
| **🐚 Shell**                | [Fish](https://fishshell.com/) with [Starship](https://starship.rs/) prompt                                                                             |
| **✏️ Editor**               | [Neovim](https://neovim.io/) with LSP support                                                                                                           |
| **🎨 Theming**              | [Matugen](https://github.com/InioX/matugen) for dynamic color generation from wallpapers                                                                |
| **🚀 Application Launcher** | [Rofi](https://github.com/davatorium/rofi)                                                                                                              |
| **🔔 Notifications**        | [Dunst](https://dunst-project.org/)                                                                                                                    |
| **📋 Clipboard Manager**    | wl-clipboard & cliphist                                                                                                                                |
| **🔊 Audio Server**         | [PipeWire](https://pipewire.org/)                                                                                                                      |
| **🏞️ Wallpaper Setter**     | Custom scripts at [`nixos/hyprland/wset`](./nixos/hyprland/wset) and [`nixos/hyprland/wset-backend`](./nixos/hyprland/wset-backend)                   |
| **📦 Dotfile Manager**      | [GNU Stow](https://www.gnu.org/software/stow/)                                                                                                         |

## 📂 Structure

The repository is organized as follows:

### Core Configuration

- **`nixos/`**: Complete NixOS system configuration
  - `configuration.nix`: Main system entry point
  - `foundation/`: Core system layer (6 modules)
    - `base.nix`: System base and core packages
    - `git.nix`: Git and version control setup
    - `network.nix`: Network and connectivity configuration
    - `power.nix`: Power management and battery settings
    - `shell.nix`: Shell environment (Fish, Starship) and aliases
    - `default.nix`: Foundation module aggregation
  - `modules/`: Feature-specific modules (8 modules)
    - `audio.nix`: PipeWire audio system configuration
    - `content.nix`: Content and media applications
    - `gaming.nix`: Gaming-related packages and configuration
    - `graphics.nix`: GPU drivers (NVIDIA with PRIME, Intel iGPU) and graphics settings
    - `theming.nix`: Matugen and system-wide theming
    - `toolbox.nix`: Development tools and languages (Python, Rust, C/C++, Node.js, Java, etc.)
    - `utility.nix`: System utilities and general tools
    - `default.nix`: Module aggregation and imports
  - `hyprland/`: Window manager configuration
    - `default.nix`: Hyprland setup and environment packages
    - `hypridle.conf`: Idle management configuration
    - `hyprlock.conf`: Lock screen configuration
    - `modules/`: Lua-based modular Hyprland configuration
      - `keys.lua`: Keybinds
      - `setts.lua`: Settings
      - `decor.lua`: Decorations
      - `evars.lua`: Environment variables
      - `wrules.lua`: Window rules
      - `start.lua`: Startup commands
      - `hyprland-colors.lua`: Dynamic color theming
    - `clipman`, `wset`, `wset-backend`: Utility scripts
  - `qtile/`: Qtile window manager configuration (alternative setup)
- **`flake.nix`**: Nix Flake configuration with stable (nixos-26.05) and unstable channels
- **`flake.lock`**: Locked dependency versions

### Application Configurations

- **`.config/`**: Application-specific configurations
  - `hypr/`: Hyprland window manager configuration
    - `modules/`: Lua-based modular configuration (keybinds, settings, decorations, environment variables, window rules, startup, colors, anime mode)
    - `hypridle.conf`: Idle management
    - `hyprlock.conf`: Lock screen appearance
    - `hyprland.lua`: Main Hyprland entry point in Lua
  - `alacritty/`: Alacritty terminal emulator configuration
  - `kitty/`: Kitty terminal emulator configuration
  - `fish/`: Fish shell configuration
  - `rofi/`: Rofi application launcher configuration
  - `picom/`: Picom compositor configuration
  - `aria2/`: Aria2 download manager configuration
  - `matugen/`: Dynamic color generation configuration
    - `templates/`: Color templates for various applications
  - `tealdeer/`: Tealdeer (tldr) configuration
  - `qtile/`: Qtile window manager configuration (alternative)

### Scripts & Utilities

- **`.local/bin/`**: Custom utility scripts
  - `rebuild`: NixOS system rebuild helper
  - `uprebuild`: NixOS system rebuild with updates
  - `cwifi`: WiFi connection management utility
  - `setup-git`: Git configuration setup
  - `stickers`: Sticker asset management
  - `age`: Age encryption utility
  - `multi_git_setup`: Multi-account Git setup helper
  - `bluerofi`: Bluetooth management via Rofi
  - `rofi-copyq`: Clipboard management via Rofi
  - `icon_picker`: Icon picker utility
  - `powermenu`: Power menu utility
- **`nixos/hyprland/`**: Wallpaper and display utilities
  - `wset`, `wset-backend`: Wallpaper management and backend color generation
  - `clipman`: Clipboard management utility


### Documentation & Miscellaneous

- **`refrence/`**: Technical guides and documentation
  - `git_guide.md`: Git workflow notes and best practices
  - `git_multi_account_setup.txt`: Multi-account Git setup reference
  - `substitution-regex-guide.md`: Regular expression patterns and substitution techniques
  - `systemd_guide.md`: Systemd service management and configuration
  - `xargs-guide.md`: Advanced xargs usage and patterns
  - `TIGER_STYLE.md`: Programming style guide and best practices
  - `d_s.md`: Additional technical documentation
  - `bookmarks.html`: Curated collection of useful web resources
  - `useful_commands.md`: Collection of useful system commands and patterns
  - `animestowatch.txt`: Anime watchlist notes
  - `logo.png`: Repository logo image
- **`.local/share/`**: Shared application data and assets
- **`.vimrc`**: Vim configuration (for compatibility)
- **`.gitignore`**: Git ignore patterns
- **`.stowrc`**: GNU Stow configuration for dotfile management
- **`LICENSE`**: MIT License for the project
- **`README.md`**: This file

## 🚀 Usage

To use these dotfiles, you can follow these steps:

1.  **Clone the repository:**
    ```bash
    git clone -b Hyprland https://github.com/RHroot/env.git
    ```
2.  **Install NixOS:**
    Follow the official NixOS installation guide to install NixOS on your system.
3.  **Symlink the configuration:**
    This repository uses `stow` to manage dotfiles. From the root of the repository, run:
    ```bash
    stow .
    ```
4.  **Rebuild the system:**
    Navigate to the `nixos/` directory and run:
    ```bash
    nixos-rebuild switch --flake .#<your-hostname>
    ```
    Replace `<your-hostname>` with the hostname of your machine, which you can find in the `flake.nix` file.

## 🎨 Customization

### System Configuration

- **NixOS modules**: Edit files in `nixos/foundation/` and `nixos/modules/` for system-level changes
- **Flake channels**: Modify `flake.nix` to adjust package sources (stable/unstable)
- **User settings**: Update hostname, username, and domain in `flake.nix` under the `env` variable

### Application Configuration

- **Hyprland**: Edit Lua modules in `.config/hypr/modules/` for specific aspects (keybinds, settings, decorations, etc.)
- **Theming**: Modify `.config/matugen/config.toml` and templates for color scheme generation
- **Shell**: Customize Fish configuration in `.config/fish/` and bash aliases in `nixos/foundation/shell.nix`
- **Neovim**: Available system-wide with LSP support

### Applying Changes

- **System changes**: Use `rebuild` or `uprebuild` scripts in `.local/bin/`, or run:
  ```bash
  cd ~/env && nixos-rebuild switch --flake .#rhroot
  ```
- **Dotfile changes**: Most application configs are symlinked via Stow and take effect immediately or after reloading the application
- **Theme changes**: Run `wset` or `wset-backend` to regenerate colors from a new wallpaper

## ✨ Key Features

- **🔄 Hybrid NixOS Flakes Setup**: Uses both stable (nixos-26.05) and unstable channels via overlays for maximum stability and cutting-edge packages
- **📦 Modular System Architecture**:
  - Foundation layer: Core system functionality (base, git, network, power, shell with Fish & Starship)
  - Module layer: Feature-specific configurations (audio, content, gaming, graphics, theming, toolbox, utility)
- **🎯 Highly Customized Hyprland Environment**:
  - Modular Lua configuration split into dedicated modules (keybinds, settings, decorations, environment variables, window rules, startup, colors)
  - Integrated idle management (Hypridle), lock screen (Hyprlock), and screenshot tool (Hyprshot)
- **🎨 Dynamic System-Wide Theming**:
  - [Matugen](https://github.com/InioX/matugen) generates color schemes from wallpapers
  - Custom templates for Alacritty, Kitty, Rofi, and Hyprland
  - Consistent theming across all applications
- **💻 Comprehensive Development Environment**:
  - **Python**: Python 3.13, LSP, uv package manager
  - **Web**: Node.js, bun, TypeScript
  - **Systems**: C/C++ (gcc, clang), Rust, Zig, Java (JDK 21)
  - **Scripting**: Lua
  - **Tools**: Neovim, Lazygit, jq, nmap, strace, pkg-config
  - **Containerization**: Podman with Compose support
- **⚡ Performance Optimizations**:
  - Custom PipeWire configuration for audio
  - Automatic Nix garbage collection and store optimization
  - NVIDIA GPU with PRIME offload for hybrid graphics
  - Intel media driver with VAAPI support
  - Swap file with configured swappiness
- **🛠️ Custom Utility Scripts**: Collection of helper scripts for system rebuilds, wallpaper management, WiFi control, Bluetooth management, and more
- **📚 Extensive Documentation**: Guides on git-subtree, regex substitution, systemd, xargs, and Tiger Style programming in `refrence/` directory
- **🔒 Security Features**: Hyprland login, rtkit enabled, passwordless sudo for wheel group
- **🐟 Modern Shell Environment**: Fish shell with Starship prompt for a modern terminal experience
- **🎮 Gaming Support**: Configured gaming packages and utilities for enhanced gaming experience

## 📚 Guides

This repository includes a collection of technical guides and resources in the `refrence/` directory:

- **`git_guide.md`**: Git workflow notes and best practices
- **`git_multi_account_setup.txt`**: Multi-account Git setup reference
- **`substitution-regex-guide.md`**: Regular expression patterns and substitution techniques
- **`systemd_guide.md`**: Systemd service management and configuration
- **`xargs-guide.md`**: Advanced xargs usage and patterns
- **`TIGER_STYLE.md`**: Programming style guide and best practices
- **`useful_commands.md`**: Collection of useful system commands and patterns
- **`d_s.md`**: Additional technical documentation
- **`bookmarks.html`**: Curated collection of useful web resources
- **`animestowatch.txt`**: Anime watchlist notes

## 📜 License

This repository is licensed under the [MIT License](LICENSE).
