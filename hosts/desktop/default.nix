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
    "${modules}/desktop-env.nix"
    "${modules}/secrets.nix"

    "${modules}/boot.nix"
    "${modules}/networking.nix"
    "${modules}/bluetooth.nix"
    "${modules}/users.nix"

    "${modules}/hyprland.nix"
    "${modules}/hyprland-options.nix"
    "${modules}/hostname-option.nix"

    "${self}/features/browser/helium-system.nix"
    "${self}/features/media"
    "${self}/features/dev"
    "${self}/features/desktop/packages.nix"

    "${modules}/base-packages.nix"

    "${modules}/docker.nix"

    "${self}/features/gaming"

    "${modules}/nix.nix"

    "${self}/features/headroom.nix"
  ];
}
