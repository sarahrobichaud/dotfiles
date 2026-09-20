{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    rofi
    dunst
    libnotify
    grim
    slurp
    wl-clipboard
    pavucontrol
    obsidian
    discord
    signal-desktop
    protonmail-desktop
    firefox
  ];
}
