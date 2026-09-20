{
  pkgs,
  ...
}: {
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  environment.systemPackages = with pkgs; [
    waybar
    quickshell
    hyprpaper
    hyprcursor
    nordzy-cursor-theme
  ];
}
