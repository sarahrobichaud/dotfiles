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
    # ../../features/browser/firefox.nix  # INACTIVE: glass tab bar didn't render; kept for reference
    ../../features/desktop/hyprland.nix
  ];
}
