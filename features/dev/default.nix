{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    vscode
    zed-editor-fhs
    neovim
    vim
    git
    lazygit
    lazydocker
    nodejs
    pnpm
    uv
    nixd
    bruno
    tableplus
    texliveFull
    zathura
    appimage-run
  ];
}
