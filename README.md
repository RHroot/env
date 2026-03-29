# <img src="refrence/logo.png" alt="Logo" width="80" align="center"> My NixOS Dotfiles

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
| **🏞️ Wallpaper Setter**     | Custom scripts at [`nixos/modules/WM/wset`](./nixos/modules/WM/wset) and [`nixos/modules/WM/wset-backend`](./nixos/modules/WM/wset-backend)                                                |
| **📦 Dotfile Manager**      | [GNU Stow](https://www.gnu.org/software/stow/)                                                                                                                                             |

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
    - `shell.nix`: Shell environment and aliases
    - `default.nix`: Foundation module aggregation
  - `modules/`: Feature-specific modules (8 modules)
    - `audio.nix`: PipeWire and audio system configuration
    - `content.nix`: Content and media applications
    - `graphics.nix`: GPU drivers and graphics settings
    - `theming.nix`: Matugen and system-wide theming
    - `toolbox.nix`: Development tools and languages
    - `utility.nix`: System utilities and general tools
    - `video.nix`: Video codecs and multimedia support
    - `WM/`: Window management module
      - `hyprland.nix`: Hyprland window manager configuration
      - `default.nix`: WM module aggregation
      - `wset`, `wset-backend`, `bar-refresh`: Utility scripts
    - `default.nix`: Module aggregation and imports
- **`flake.nix`**: Nix Flake configuration with stable and unstable channels
- **`flake.lock`**: Locked dependency versions

### Application Configurations

- **`.config/`**: Application-specific configurations (~141 files across 27 directories)
  - `hypr/`: Hyprland window manager configuration
    - `conf/`: Modular configuration files (animations, decorations, environmental variables, keybinds, monitors, settings, startup, windowrules)
    - `hyprland.conf`: Main Hyprland configuration entry point
    - `hypridle.conf`: Idle management configuration
    - `hyprlock.conf`: Lock screen configuration
    - `hyprshot.conf`: Screenshot tool configuration
  - `nvim/`: Neovim setup with modular Lua configuration
    - `lua/core/`: Core editor settings and configuration
    - `lua/plugins/`: Plugin specifications and lazy loading
    - `snippets/`: LuaSnip snippet definitions
  - `shell/`: Zsh shell configuration
    - `.zshrc`: Main shell configuration
    - `func`: Shell function definitions
    - `alias`: Command aliases
    - `prompt`: Custom prompt script
    - `.p10k.zsh`: Powerlevel10k prompt configuration
    - `powerlevel10k/`: Powerlevel10k theme with gitstatus integration
  - `alacritty/`: Alacritty terminal emulator configuration
  - `kitty/`: Kitty terminal emulator configuration
  - `tmux/`: Tmux multiplexer configuration
  - `waybar/`: Waybar status bar configuration
  - `dunst/`: Dunst notification daemon configuration
  - `fuzzel/`: Fuzzel application launcher configuration
  - `aria2/`: Aria2 download manager configuration
  - `matugen/`: Dynamic color generation configuration
    - `templates/`: Color templates for various applications

### Scripts & Utilities

- **`.local/bin/`**: Custom utility scripts
  - `rebuild`, `uprebuild`: NixOS system rebuild helpers
  - `cwifi`: WiFi connection management utility
  - `setup-git`: Git configuration setup
  - `stickers`: Sticker asset management
  - `age`: Age encryption utility
  - `multi_git_setup`: Multi-account Git setup helper
- **`nixos/modules/WM/`**: Wallpaper and display utilities
  - `wset`, `wset-backend`: Wallpaper management and backend color generation
  - `bar-refresh`: Status bar refresh script

### Documentation & Miscellaneous

- **`refrence/`**: Technical guides and documentation
  - `git_guide.md`: Git workflow notes and best practices
  - `git_multi_account_setup.txt`: Multi-account Git setup reference
  - `substitution-regex-guide.md`: Regular expression patterns and substitution techniques
  - `systemd_guide.md`: Systemd service management and configuration
  - `xargs-guide.md`: Advanced xargs usage and patterns
  - `TIGER_STYLE.md`: Programming style guide and best practices
  - `bookmarks.html`: Curated collection of useful web resources
  - `useful_commands.md`: Collection of useful system commands and patterns
  - `animestowatch.txt`: Anime watchlist notes
  - `logo.png`: Repository logo image
- **`.local/share/`**: Shared application data and assets
- **`.config/shell/powerlevel10k/gitstatus/`**: Gitstatus C++ implementation for fast git status
- **`.zshenv`**: Shell environment variables and initialization
- **`.vimrc`**: Vim configuration (for compatibility)
- **`.gitignore`**: Git ignore patterns
- **`.stowrc`**: GNU Stow configuration for dotfile management
- **`LICENSE`**: MIT License for the project
- **`README.md`**: This file
- **`Stickers/`**: Collection of sticker assets for customization

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

- **Hyprland**: Edit modular configs in `.config/hypr/conf/` for specific aspects (keybinds, animations, etc.)
- **Theming**: Modify `.config/matugen/config.toml` and templates for color scheme generation
- **Shell**: Customize `.config/shell/.zshrc`, `alias`, `func`, and `.p10k.zsh` for shell behavior
- **Neovim**: Edit Lua configs in `.config/nvim/lua/` for editor customization

### Applying Changes

- **System changes**: Use `rebuild` or `uprebuild` scripts in `.local/bin/`, or run:
  ```bash
  nixos-rebuild switch --flake /path/to/env'.#rhroot_nix'
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
- **`useful_commands.md`**: Collection of useful system commands and patterns

## 📜 License

This repository is licensed under the [MIT License](LICENSE).
