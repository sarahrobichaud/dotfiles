{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.features.dev;
in
{
  options.features.dev.enable = lib.mkEnableOption "dev feature (editors, git tooling, language runtimes)";

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      vscode
      zed-editor-fhs
      neovim
      vim
      git
      rustc
      cargo
      rust-analyzer
      gcc
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
  };
}
