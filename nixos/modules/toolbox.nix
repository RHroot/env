{
  config,
  pkgs,
  env,
  ...
}: {
  environment.systemPackages = with pkgs; [
    # === Python Development ===
    python313 # Python 3.13 interpreter
    python313Packages.ruff # Fast Python linter and formatter
    python313Packages.uv # Extremely fast Python package and environment manager

    # === Lua Development ===
    lua # Lua programming language interpreter

    # === C/C++ Development ===
    gcc # GNU C/C++ compiler toolchain
    cmake # Cross-platform build system generator
    ninja # Fast build system used with CMake
    clang-tools # Clang-based developer tools (clangd, format, tidy)

    # === Rust Development ===
    rustup # Rust toolchain installer and version manager

    # === Go Development ===
    go

    # === Zig Development ===
    zig

    # === Web Development tools ===
    nodejs
    bun # All-in-one JS runtime, bundler, and package manager
    prettierd # Fast daemonized code formatter (Prettier)
    jq # Command-line JSON processor

    # === CyberSecurity ===
    nmap # Network scanner and port discovery tool
    strace # Diagnostic tool to monitor system calls
    tcpdump # Command-line packet analyzer

    # === Utility tools ===
    lazygit # Terminal UI for Git operations
    opencode # Open source code search engine
    tree-sitter # Incremental parsing system for syntax highlighting and code analysis
  ];
  # === Neovim ===
  programs.neovim = {
    enable = true;
    package = pkgs.unstable.neovim-unwrapped;
    defaultEditor = true;
  };
  services.ollama = {
    enable = true;
    package = pkgs.ollama;
    acceleration = "cuda";
  };
}
