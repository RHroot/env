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

    # === Web Development ===
    bun # Fast, modern, all-in-one CLI for web dev
    prettierd # Formatter for JavaScript, HTML, CSS, JSON, GraphQL, Markdown, YAML, and more

    # === Markdown ===
    marksman # Markdown lsp server
    mdformat # Markdown formatter

    # === bash/sh ===
    shfmt # Shell script formatter
    bash-language-server # Bash language server

    # === sql ===
    sqls # SQL language server protocol
    postgresql # SQL
    sql-formatter # SQL formatter

    # === Lua Development ===
    lua # Lua programming language interpreter
    stylua # Lua code formatter
    lua-language-server # Lua language server

    # === Python Development ===
    python314 # Python interpreter
    python314Packages.uv # Extremely fast Python package and environment manager
    python314Packages.ruff # Python linter/formatter
    python314Packages.python-lsp-server # Python language server

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
