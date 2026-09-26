{ pkgs, ... }:

{
  qt.enable = true;

  environment.systemPackages = with pkgs; [
    # Launcher / notifications
    rofi
    dunst
    libnotify

    # System / file management
    pavucontrol
    obsidian
    nautilus
  ];

  services.gvfs.enable = true;
}