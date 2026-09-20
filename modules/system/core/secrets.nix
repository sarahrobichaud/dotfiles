{ inputs, config, ... }:
{
  imports = [ inputs.sops-nix.nixosModules.sops ];

  sops = {
    defaultSopsFile = "${../../..}/secrets.yaml";
    age.keyFile = "/var/lib/sops-nix/key.txt";

    secrets."openrouter/key" = {
      owner = "zyriel";
      mode = "0400";
      restartUnits = [ "waybar.service" ];
    };

    templates."headroom-env" = {
      content = ''
        OPENROUTER_API_KEY=${config.sops.placeholder."openrouter/key"}
      '';
      owner = "zyriel";
      mode = "0400";
      restartUnits = [ "headroom.service" ];
    };
  };
}
