{ ... }:
{

  imports = [
    ./scripts.nix
  ];

  home = {
    username = "zyriel";
   	homeDirectory = "/home/zyriel";
   	stateVersion = "26.05";

    sessionVariables = {
      BROWSER = "helium";
    };
  };

  programs.home-manager.enable = true;
}
