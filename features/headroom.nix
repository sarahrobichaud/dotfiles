{
  config,
  lib,
  ...
}:
let
  cfg = config.features.headroom;
in
{
  options.features.headroom.enable = lib.mkEnableOption "headroom compression proxy user service";

  config = lib.mkIf cfg.enable {
    systemd.user.services.headroom = {
      description = "Headroom compression proxy";
      after = [ "sops-nix.service" ];
      wantedBy = [ "default.target" ];

      serviceConfig = {
        ExecStart = "%h/.local/bin/headroom proxy --backend openrouter --port 8787";
        EnvironmentFile = "/run/secrets/rendered/headroom-env";
        Environment = [
          "HEADROOM_DISABLE_KOMPRESS_OPENAI=1"
          "HEADROOM_BEACON=off"
        ];
        Restart = "on-failure";
      };
    };
  };
}
