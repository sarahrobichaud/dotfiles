{ self, ... }:
let
  core = "${self}/modules/system/core";
  desktop = "${self}/modules/system/desktop";
  software = "${self}/modules/system/software";
  virtualisation = "${self}/modules/virtualisation";
  hardware = "${self}/modules/hardware";
in
{
  modules = [
    "${self}/hosts/desktop/hardware.nix"
    "${self}/hosts/desktop/nas.nix"
    "${hardware}/graphics.nix"


    # Temporary before clean up
    "${core}/temp.nix"
    "${self}/modules/locale.nix"
    "${self}/modules/audio.nix"
    "${self}/modules/network-base.nix"
    "${self}/modules/desktop-env.nix"
    "${self}/modules/secrets.nix"

    "${self}/modules/boot.nix"
    "${core}/networking.nix"
    "${self}/modules/bluetooth.nix"
    "${self}/modules/users.nix"

    "${desktop}/hyprland.nix"

    "${virtualisation}/docker.nix"

    "${self}/modules/nix.nix"
    "${software}/all.nix"
    "${software}/nautilus.nix"

  ];
}
