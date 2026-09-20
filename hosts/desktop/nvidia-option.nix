{ lib, ... }:
{
  options.hosts.desktop.nvidia = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "This host has an NVIDIA GPU (gates NVIDIA hardware config and initrd modules)";
  };
}
