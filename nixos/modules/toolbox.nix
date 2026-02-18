{
  config,
  pkgs,
  env,
  ...
}: {
  environment.systemPackages = with pkgs; [
    # === Python Development ===
    python313 # Python 3.13 interpreter
    python313Packages.python-lsp-server # Language Server Protocol support for Python
    python313Packages.debugpy # Python debugger used by editors and IDEs
    python313Packages.ruff # Fast Python linter and formatter
    python313Packages.uv # Extremely fast Python package and environment manager

    # === Lua Development ===
    lua # Lua programming language interpreter
    lua-language-server # Language server for Lua (LSP support)
    stylua # Opinionated Lua code formatter

    # === C/C++ Development ===
    gcc # GNU C/C++ compiler toolchain
    cmake # Cross-platform build system generator
    ninja # Fast build system used with CMake
    clang-tools # Clang-based developer tools (clangd, format, tidy)

    # === Rust Development ===
    rustup # Rust toolchain installer and version manager

    # === Web Development tools ===
    nodejs_latest # Latest Node.js runtime
    bun # All-in-one JS runtime, bundler, and package manager
    nodePackages_latest.typescript-language-server # LSP server for TypeScript and JavaScript
    nodePackages_latest.vscode-langservers-extracted # HTML/CSS/JSON/ESLint language servers
    tailwindcss-language-server # LSP server for Tailwind CSS
    prettierd # Fast daemonized code formatter (Prettier)
    vtsls # Advanced TypeScript language server
    jq # Command-line JSON processor

    # === Formatters ===
    shfmt # Shell script formatter
    alejandra # Opinionated Nix code formatter

    # === CyberSecurity ===
    nmap # Network scanner and port discovery tool
    tshark # CLI network protocol analyzer (Wireshark backend)
    strace # Diagnostic tool to monitor system calls
    tcpdump # Command-line packet analyzer

    # === Utility tools ===
    lazygit # Terminal UI for Git operations
    opencode # Open source code search engine
  ];
  # === Neovim ===
  programs.neovim = {
    enable = true;
    package = pkgs.unstable.neovim-unwrapped;
    defaultEditor = true;
  };
}
