{
  config,
  pkgs,
  env,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    # === Nix Formatter ===
    nixfmt

    # === Rust Development ===
    rustup # Rust toolchain installer

    # === Lua Development ===
    lua # Lua programming language interpreter
    luarocks # Lua package manager

    # === Python Development ===
    python314 # Python interpreter
    python314Packages.uv # Extremely fast Python package and environment manager

    # === C/C++ Development ===
    lldb # Next generation, high-performance debugger
    clang # C/C++/Objective-C compiler
    cmake # Build, test, and package software
    gnumake # GNU Make
    clang-tools # Clang static analyzer

    # === Utility tools ===
    eww # ElKovar's Wacky Widget
    tmux # Terminal multiplexer
    lazygit # Terminal UI for Git operations
    opencode # Open source code search engine
    pkg-config # Package management tool for libraries
    # podman-compose # Compose multiple containers with a single command
  ];
  programs.vim = {
    enable = true;
  };
  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };
  # virtualisation = {
  #   containers.enable = true;
  #   podman = {
  #     enable = true;
  #     dockerCompat = true;
  #     defaultNetwork.settings.dns_enabled = true;
  #   };
  # };
  environment.variables = {
    EDITOR = "vi";
    VISUAL = "vi";
  };
}
