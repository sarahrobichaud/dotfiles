let
  SHARED_CONFIG = [
    ../config/base-config.nix
    ../.
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
