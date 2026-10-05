let
  SHARED_CONFIG = [
    ../config/base-config.nix
    ../default.nix
    {
      features.desktop.hyprland.enable = true;
    }
  ];
in
{
  zyriel = SHARED_CONFIG ++ [
    ../../features/shell/bash.nix
    ../../features/terminal/ghostty.nix
    ../../features/browser/helium.nix
    ../../features/desktop/hyprland.nix
  ];
}
