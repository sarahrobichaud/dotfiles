{ config, lib, pkgs, ... }:
let
  cfg = config.dotfiles.user;
in
{
  options.dotfiles.user.name = lib.mkOption {
    type = lib.types.str;
    default = "zyriel";
    description = "Primary user account name";
  };

  config = {
    users.users.${cfg.name} = {
      isNormalUser = true;
      description = "Zyriel";
      extraGroups = [ "networkmanager" "wheel" ];
      shell = pkgs.bash;
    };
  };
}
