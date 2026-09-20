{ pkgs, ... }:

{
  qt.enable = true;

  environment.systemPackages = [
    pkgs.nautilus
  ];

  services.gvfs.enable = true;
}
