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
    rustup # Rust toolchain installer and version manager

    # === Web Development tools ===
    nodejs # JavaScript runtime environment
    bun # All-in-one JS runtime, bundler, and package manager
    prettierd # Fast daemonized code formatter (Prettier)

    # === CyberSecurity ===
    nmap # Network scanner and port discovery tool
    strace # Diagnostic tool to monitor system calls
    tcpdump # Command-line packet analyzer

    # === Utility tools ===
    lapce # Code editor with a focus on speed and extensibility
    typst # Strongly typed WYSIWYG markup language
    lazygit # Terminal UI for Git operations
    opencode # Open source code search engine
    pkg-config # Package management tool for libraries
    tree-sitter # Incremental parsing system for syntax highlighting and code analysis
    jetbrains-toolbox # JetBrains Toolbox App for managing JetBrains IDEs
  ];
  programs.vim = {
    enable = true;
    package = pkgs.unstable.vim-full;
  };
  programs.neovim = {
    enable = true;
    package = pkgs.unstable.neovim-unwrapped;
  };
}
