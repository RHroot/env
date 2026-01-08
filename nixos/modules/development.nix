{
  config,
  pkgs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    # === Python Development ===
    python313
    python313Packages.python-lsp-server
    python313Packages.debugpy
    python313Packages.ruff
    python313Packages.uv
    # === Lua Development ===
    lua
    lua-language-server
    stylua
    # === C/C++ Development ===
    gcc
    cmake
    ninja
    clang-tools
    # === Rust Development ===
    rustup
    # === Web Development tools ===
    nodejs_latest
    pnpm
    bun
    nodePackages_latest.typescript-language-server
    nodePackages_latest.vscode-langservers-extracted
    tailwindcss-language-server
    prettierd
    vtsls
    jq
    # === Formatters ===
    shfmt
    alejandra
    # === Utility tools ===
    unstable.neovide
    ollama-cuda
    zed-editor
    lazygit
    pgcli
    # === CyberSecurity ===
    nmap
    tshark
  ];
  # === Neovim ===
  programs.neovim = {
    enable = true;
    package = pkgs.unstable.neovim-unwrapped;
    defaultEditor = true;
  };
}
