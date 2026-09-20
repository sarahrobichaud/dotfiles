{ config, lib, pkgs, ... }:
{
  boot.loader.systemd-boot.configurationLimit = 1;
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.initrd.kernelModules = lib.mkIf config.hosts.desktop.nvidia [
    "nvidia"
    "nvidia_modeset"
    "nvidia_uvm"
    "nvidia_drm"
  ];
}
