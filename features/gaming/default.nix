{ pkgs, ... }:

{
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = false; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = false; # Open ports in the firewall for Source Dedicated Server
    localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
    gamescopeSession.enable = true;
  };

  hardware.xone.enable = true;

  programs.gamescope.enable = true;
  programs.gamemode.enable = true;

  environment.sessionVariables = {
    STEAM_EXTRA_COMPAT_TOOLS_PATHS = "/home/zyriel/.steam/root/compatibilitytools.d";
  };

  environment.systemPackages = with pkgs; [
    lutris
    mangohud
    protonup-ng
    qbittorrent
  ];
}
