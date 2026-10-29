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
  options.features.dev = {
    enable = lib.mkEnableOption "dev feature (editors, git tooling, language runtimes)";

    light = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Light profile: CLI-only tooling, skips GUI editors, LaTeX and DB clients";
    };
  };

  config = lib.mkIf cfg.enable {
    # Local dev service names; /etc/hosts wins over mDNS/LAN resolver lookups.
    networking.hosts = {
      "127.0.0.1" = [
        "pantry.local"
        "mail.local"
        "api.local"
        "tournament.local"
      ];
    };

    environment.systemPackages =
      (with pkgs; [
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
      ])
      ++ lib.optionals (!cfg.light) (
        with pkgs; [
          vscode
          zed-editor-fhs
          bruno
          tableplus
          texliveFull
          zathura
          appimage-run
        ]
      );
  };
}
