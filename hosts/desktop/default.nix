{ self, ... }:
let
  modules = "${self}/modules";
in
{
  modules = [
    "${self}/hosts/desktop/hardware.nix"
    "${self}/hosts/desktop/nas.nix"
    "${self}/hosts/desktop/nvidia-option.nix"
    "${self}/hosts/desktop/gpu.nix"

    "${modules}/locale.nix"
    "${modules}/audio.nix"
    "${modules}/network-base.nix"
    "${self}/hosts/desktop/networking.nix"
    "${modules}/desktop-env.nix"
    "${modules}/secrets.nix"

    "${modules}/boot.nix"
    "${modules}/bluetooth.nix"
    "${modules}/users.nix"

    "${modules}/hyprland-system.nix"
    "${modules}/hostname-option.nix"

    "${self}/features/browser"
    "${self}/features/media"
    "${self}/features/dev"
    "${self}/features/desktop"

    "${modules}/base-packages.nix"

    "${modules}/docker.nix"

    "${self}/features/gaming"

    "${modules}/nix.nix"
  ];
}
