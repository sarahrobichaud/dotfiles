{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.features.gaming;
in
{
  options.features.gaming.enable = lib.mkEnableOption "gaming feature (steam, lutris, emulators)";

  config = lib.mkIf cfg.enable {
    programs.steam = {
      enable = true;
      remotePlay.openFirewall = false;
      dedicatedServer.openFirewall = false;
      localNetworkGameTransfers.openFirewall = true;
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
  };
}
