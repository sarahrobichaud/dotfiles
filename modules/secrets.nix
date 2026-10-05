{ inputs, config, lib, ... }:
{
  imports = [ inputs.sops-nix.nixosModules.sops ];

  options.dotfiles.secrets.waybarRestartUnits = lib.mkOption {
    type = lib.types.listOf lib.types.str;
    default = [ ];
    description = "Units to restart when the openrouter key secret changes";
  };

  config = {
    sops = {
      defaultSopsFile = "${../secrets.yaml}";
      age.keyFile = "/var/lib/sops-nix/key.txt";

      secrets."openrouter/key" = {
        owner = "zyriel";
        mode = "0400";
        restartUnits = config.dotfiles.secrets.waybarRestartUnits;
      };
    };
  };
}
