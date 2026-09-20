{
  nixpkgs.config.allowUnfree = true;

  nix.settings.experimental-features = [ "flakes" "nix-command" ];

  programs.nix-ld.enable = true;
}
