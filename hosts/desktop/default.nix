{ self, ... }:
let
  core = "${self}/modules/system/core";
  desktop = "${self}/modules/system/desktop";
  software = "${self}/modules/system/software";
  virtualisation = "${self}/modules/system/virtualisation";
  hardware = "${self}/modules/hardware";
in
{
  modules = [
    "${self}/hosts/desktop/hardware.nix"
    "${hardware}/graphics.nix"


    # Temporary before clean up
    "${core}/temp.nix"
    "${core}/secrets.nix"

    "${core}/boot.nix"
    "${core}/networking.nix"
    "${core}/bluetooth.nix"
    "${core}/users.nix"

    "${desktop}/hyprland.nix"

    "${virtualisation}/docker.nix"

    "${software}/nixpkgs.nix"
    "${software}/all.nix"
    "${software}/nautilus.nix"

  ];
}
