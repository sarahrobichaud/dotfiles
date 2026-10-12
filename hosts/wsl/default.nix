{ self, ... }:
let
  modules = "${self}/modules";
in
{
  modules = [
    "${modules}/locale.nix"
    "${modules}/hostname-option.nix"
    "${modules}/nix.nix"

    "${self}/features/dev"

    { nixpkgs.hostPlatform = "x86_64-linux"; }

    (
      { pkgs, ... }:
      {
        wsl.enable = true;
        wsl.defaultUser = "zyriel";

        # NixOS-WSL declares the default user itself (isNormalUser, uid 1000,
        # wheel group, passwordless sudo); only layer host-specific bits here.
        users.users.zyriel = {
          description = "Zyriel";
          shell = pkgs.bash;
        };
      }
    )
  ];
}
