{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    discord
    signal-desktop
    protonmail-desktop
  ];
}