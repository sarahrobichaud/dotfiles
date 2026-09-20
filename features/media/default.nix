{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.features.media;
in
{
  options.features.media.enable = lib.mkEnableOption "media feature (obs, streaming clients, media taggers)";

  config = lib.mkIf cfg.enable {
    programs.obs-studio = {
      enable = true;
      enableVirtualCamera = true;

      package = (
        pkgs.obs-studio.override {
          cudaSupport = true;
        }
      );
    };

    environment.systemPackages = with pkgs; [
      jellyfin-tui
      feishin
      picard
      nicotine-plus
      guvcview
    ];
  };
}
