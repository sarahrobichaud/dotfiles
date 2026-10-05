{ pkgs, ... }:

{
  qt.enable = true;

  environment.systemPackages = with pkgs; [
    rofi
    dunst
    libnotify

    pavucontrol
    obsidian
    nautilus
  ];

  services.gvfs.enable = true;
}