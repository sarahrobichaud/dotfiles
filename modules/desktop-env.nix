{ pkgs, ... }:

{
  services.gnome.gnome-keyring.enable = true;

  services.xserver = {
    autoRepeatDelay = 100;
    autoRepeatInterval = 35;
  };

  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  services.flatpak.enable = true;
  environment.homeBinInPath = true;
}
