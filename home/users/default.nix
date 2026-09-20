let
  SHARED_CONFIG = [
    ../config/base-config.nix
    ../.
    {
      features.desktop.hyprland = {
        enable = true;
        monitors = [
          {
            output = "DP-2";
            mode = "3440x1440@143.97";
            position = "-900x1080";
            scale = "1";
          }
          {
            output = "DP-1";
            mode = "1920x1080@143.98";
            position = "0x0";
            scale = "1";
          }
        ];
      };
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
