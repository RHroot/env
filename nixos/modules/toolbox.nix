{
  config,
  pkgs,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    # === Nix Formatter ===
    nixfmt

    # === Rust Development ===
    rustup # Rust toolchain installer

    # === Markdown ===
    marksman # Markdown lsp server
    mdformat # Markdown formatter

    # === bash/sh ===
    shfmt # Shell script formatter
    bash-language-server # Bash language server

    # === Python Development ===
    uv # Extremely fast Python package and environment manager
    python314 # Python interpreter

    # === Lua Development ===
    lua # Lua programming language interpreter
    stylua # Lua code formatter
    lua-language-server # Lua language server

    # === Utility tools ===
    tmux # Terminal multiplexer
    lazygit # Terminal UI for Git operations
    opencode # Open source code search engine
    pkg-config # Package management tool for libraries
    # podman-compose # Compose multiple containers with a single command
  ];
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
    EDITOR = "nvim";
    VISUAL = "nvim";
  };
}
