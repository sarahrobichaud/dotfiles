{ lib, ... }:
{
  options.dotfiles.hostName = lib.mkOption {
    type = lib.types.str;
    default = "desktop";
    description = "Name of the host this configuration builds";
  };
}
