{
  config,
  pkgs,
  env,
  ...
}: {
  environment.systemPackages = with pkgs; [
    # === Python Development ===
    python313 # Python 3.13 interpreter
    python313Packages.uv # Extremely fast Python package and environment manager

    # === Lua Development ===
    lua # Lua programming language interpreter

    # === C/C++ Development ===
    gcc # GNU C/C++ compiler toolchain
    cmake # Cross-platform build system generator
    ninja # Fast build system used with CMake
    clang-tools # Clang-based developer tools (clangd, format, tidy)

    # === Rust Development ===
    cargo # Rust package manager
    rustc # Rust compiler

    # === Web Development tools ===
    jq # Command-line JSON processor
    bun # All-in-one JS runtime, bundler, and package manager
    nodejs # JavaScript runtime environment
    prettierd # Fast daemonized code formatter (Prettier)

    # === CyberSecurity ===
    nmap # Network scanner and port discovery tool
    strace # Diagnostic tool to monitor system calls
    tcpdump # Command-line packet analyzer

    # === Utility tools ===
    neovide # GUI for neovim
    lazygit # Terminal UI for Git operations
    opencode # Open source code search engine
    zed-editor # Text editor with a minimalistic UI
    pkg-config # Package management tool for libraries
    podman-compose # Compose multiple containers with a single command
  ];
  programs.vim = {
    enable = true;
    package = pkgs.unstable.vim;
  };
  programs.neovim = {
    enable = true;
    package = pkgs.unstable.neovim-unwrapped;
  };
  virtualisation = {
    containers.enable = true;
    podman = {
      enable = true;
      dockerCompat = true;
      defaultNetwork.settings.dns_enabled = true;
    };
  };
  xdg.mime.defaultApplications = {
    "text/*" = ["neovide-opener.desktop"];
  };
}
