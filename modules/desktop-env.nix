{ pkgs, config, lib, ... }:

let
  nvidia = config.features.desktop.hyprland.nvidiaEnv;
in
{
  services.gnome.gnome-keyring.enable = true;

  services.xserver = {
    autoRepeatDelay = 100;
    autoRepeatInterval = 35;
    videoDrivers = lib.mkIf nvidia [ "nvidia" ];
  };

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    fira-code
  ];

  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  services.flatpak.enable = true;
  environment.homeBinInPath = true;
}
