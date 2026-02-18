# <img src="pictrs/logo.png" alt="Logo" width="40" align="center"> My NixOS Dotfiles

This repository contains my personal dotfiles for my NixOS setup. It's a comprehensive configuration that includes everything from the operating system itself to my terminal, editor, and theming.

## ⚙️ System Overview

| Component                   | Details                                                                                                                                                                                    |
| --------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| **❄️ Operating System**     | [NixOS](https://nixos.org/) 25.11 with Flakes                                                                                                                                              |
| **🪟 Window Manager**       | [Hyprland](https://hyprland.org/) with [Hypridle](https://github.com/hyprwm/hypridle), [Hyprlock](https://github.com/hyprwm/hyprlock), and [Hyprshot](https://github.com/Gustash/Hyprshot) |
| **🔐 Login Manager**        | [Greetd](https://git.sr.ht/~kennylevinsen/greetd)                                                                                                                                          |
| **💻 Terminal**             | [Alacritty](https://alacritty.org/) & [Kitty](https://sw.kovidgoyal.net/kitty/)                                                                                                            |
| **🐚 Shell**                | [Zsh](https://www.zsh.org/) with [Powerlevel10k](https://github.com/romkatv/powerlevel10k)                                                                                                 |
| **✏️ Editor**               | [Neovim](https://neovim.io/) with LSP, Treesitter, and [GitHub Copilot](https://github.com/features/copilot)                                                                               |
| **🔀 Terminal Multiplexer** | [Tmux](https://github.com/tmux/tmux)                                                                                                                                                       |
| **🎨 Theming**              | [Matugen](https://github.com/InioX/matugen) for dynamic color generation from wallpapers, with the [Flat-Remix-GTK](https://github.com/daniruiz/flat-remix-gtk) theme                      |
| **📊 Status Bar**           | [Waybar](https://github.com/Alexays/Waybar)                                                                                                                                                |
| **🚀 Application Launcher** | [Fuzzel](https://codeberg.org/dnkl/fuzzel)                                                                                                                                                 |
| **🔔 Notifications**        | [Dunst](https://dunst-project.org/)                                                                                                                                                        |
| **📋 Clipboard Manager**    | wl-clipboard & cliphist                                                                                                                                                                    |
| **🔊 Audio Server**         | [PipeWire](https://pipewire.org/) & [WirePlumber](https://pipewire.pages.freedesktop.org/wireplumber/)                                                                                     |
| **📄 PDF Viewer**           | [Zathura](https://pwmt.org/projects/zathura/)                                                                                                                                              |
| **🎮 Performance Overlay**  | [MangoHud](https://github.com/flightlessmango/MangoHud)                                                                                                                                    |
| **🏞️ Wallpaper Setter**     | Custom scripts at [`~/.local/bin/wset`](./.local/bin/wset) and [`~/.local/bin/wset-backend`](./.local/bin/wset-backend)                                                                    |
| **📦 Dotfile Manager**      | [GNU Stow](https://www.gnu.org/software/stow/)                                                                                                                                             |

## 📂 Structure

The repository is organized as follows:

### Core Configuration

- **`nixos/`**: Contains the core NixOS configuration
  - `configuration.nix`: Main system configuration
  - `foundation/`: Core system modules (base, git, network, power, shell)
  - `modules/`: Feature-specific modules (audio, content, graphics, theming, toolbox, utility, video, windowmanager)
- **`flake.nix`**: Flake configuration with stable (25.11) and unstable package channels

### Application Configurations

- **`.config/`**: Application-specific configurations
  - `hypr/`: Modular Hyprland configuration
    - `conf/`: Separated configs (animations, decorations, keybinds, monitors, settings, startup, windowrules)
    - `hypridle.conf`, `hyprlock.conf`, `hyprshot.conf`: Additional Hyprland tools
  - `nvim/`: Neovim configuration with Lua modules and LSP setup
  - `shell/`: Zsh configuration with Powerlevel10k theme
  - `alacritty/`, `kitty/`: Terminal emulator configs
  - `waybar/`: Status bar configuration
  - `dunst/`, `fuzzel/`, `matugen/`, `tmux/`: Other application configs
  - `aria2/`: Aria2 download manager configuration
  - `pipewire/`, `wireplumber/`: Audio system configurations
  - `MangoHud/`: MangoHud overlay configuration

### Scripts & Utilities

- **`.local/bin/`**: Custom utility scripts
  - `wset`, `wset-backend`: Wallpaper management
  - `rebuild`, `uprebuild`: System rebuild helpers
  - `menu`, `cwifi`, `bar-refresh`, `stickers`: UI utilities
  - `setup-git`, `age`, `appdefault`: System utilities

### Documentation & Misc

- **`refrence/`**: Technical guides and documentation
- **`.stowrc`**: GNU Stow configuration for dotfile management
- **`.zshenv`**, **`.vimrc`**: Shell and editor environment files
- **`nixos-switch.log`**: Saved NixOS rebuild log

## 🚀 Usage

To use these dotfiles, you can follow these steps:

1.  **Clone the repository:**
    ```bash
    git clone https://gitlab.com/rhroot/env.git
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

- **Hyprland**: Edit modular configs in `.config/hypr/conf/` for specific aspects (keybinds, animations, etc.)
- **Theming**: Modify `.config/matugen/config.toml` and templates for color scheme generation
- **Shell**: Customize `.config/shell/.zshrc`, `alias`, `func`, and `.p10k.zsh` for shell behavior
- **Neovim**: Edit Lua configs in `.config/nvim/lua/` for editor customization

### Applying Changes

- **System changes**: Use `rebuild` or `uprebuild` scripts in `.local/bin/`, or run:
  ```bash
  nixos-rebuild switch --flake /path/to/env#rhroot-nix
  ```
- **Dotfile changes**: Most application configs are symlinked via Stow and take effect immediately or after reloading the application
- **Theme changes**: Run `wset` or `wset-backend` to regenerate colors from a new wallpaper

## ✨ Key Features

- **🔄 Hybrid NixOS Flakes Setup**: Uses both stable (nixos-25.11) and unstable channels via overlays for maximum stability and cutting-edge packages
- **📦 Modular System Architecture**:
  - Foundation layer: Core system functionality (base, git, network, power, shell)
  - Module layer: Feature-specific configurations (audio, development, graphics, theming, video, windowmanager)
- **🎯 Highly Customized Hyprland Environment**:
  - Modular configuration split into dedicated files (animations, decorations, keybinds, monitors, settings, startup, windowrules)
  - Integrated idle management (Hypridle), lock screen (Hyprlock), and screenshot tool (Hyprshot)
- **🎨 Dynamic System-Wide Theming**:
  - [Matugen](https://github.com/InioX/matugen) generates color schemes from wallpapers
  - Custom templates for Alacritty, Kitty, Fuzzel, Waybar, GTK, and Hyprland
  - Consistent theming across all applications
- **💻 Comprehensive Development Environment**:
  - **Python**: Python 3.13, LSP, debugpy, ruff, uv
  - **Web**: Node.js, pnpm, bun, TypeScript, Tailwind CSS
  - **Systems**: C/C++ (gcc, clang), Zig, Java (JDK 21, Maven, Gradle)
  - **Scripting**: Lua with LSP and formatter
  - **Database**: PostgreSQL LSP, pgcli, sqruff
- **✏️ Full-Featured Neovim Setup**:
  - LSP support for all development languages
  - Treesitter for syntax highlighting
  - GitHub Copilot integration
  - Blink completion, LuaSnip snippets, conform.nvim formatting
  - Mini plugins ecosystem (statusline, icons, AI, hipatterns)
- **⚡ Performance Optimizations**:
  - Custom PipeWire and WirePlumber configurations for audio
  - Automatic Nix garbage collection and store optimization
  - Swap file with configured swappiness
  - MangoHud for performance monitoring
- **🛠️ Custom Utility Scripts**: Collection of helper scripts for system rebuilds, wallpaper management, WiFi control, and application defaults
- **📚 Extensive Documentation**: Guides on git-subtree, regex substitution, systemd, xargs, and Tiger Style programming
- **🔒 Security Features**: Greetd login manager, rtkit enabled, passwordless sudo for wheel group

## 📚 Guides

This repository includes a collection of technical guides and resources in the `refrence/` directory:

- **`git_guide.md`**: Git workflow notes and best practices
- **`git_multi_account_setup.txt`**: Multi-account Git setup reference
- **`substitution-regex-guide.md`**: Regular expression patterns and substitution techniques
- **`systemd_guide.md`**: Systemd service management and configuration
- **`xargs-guide.md`**: Advanced xargs usage and patterns
- **`TIGER_STYLE.md`**: Programming style guide and best practices
- **`bookmarks.html`**: Curated collection of useful web resources

## 📜 License

This repository is licensed under the [MIT License](LICENSE).
