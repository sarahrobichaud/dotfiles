{ lib, ... }:
{
  options.features.desktop.hyprland.nvidiaEnv = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "This host uses NVIDIA (gates videoDrivers and Hyprland env vars)";
  };
}
