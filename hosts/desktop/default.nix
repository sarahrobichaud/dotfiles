{ self, ... }:
let
  modules = "${self}/modules";
in
{
  modules = [
    "${self}/hosts/desktop/hardware.nix"
    "${self}/hosts/desktop/nas.nix"
    "${modules}/hardware/graphics.nix"

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

    "${self}/features/browser/helium-system.nix"
    "${self}/features/media"
    "${self}/features/dev"

    "${modules}/docker.nix"

    "${self}/features/gaming"

    "${modules}/nix.nix"
    "${modules}/software-all.nix"
    "${modules}/nautilus.nix"

    "${self}/features/headroom.nix"
  ];
}
