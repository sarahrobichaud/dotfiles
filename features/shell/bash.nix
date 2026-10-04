{
  osConfig ? { },
  ...
}:
let
  hostName = osConfig.dotfiles.hostName or "desktop";
in
{
  programs.starship.enable = true;

  programs.direnv = {
    enable = true;
  };


  programs.bash = {
    enable = true;
    shellAliases = {
      check-port = "natpmpc -g 10.2.0.1 -a 1 0 tcp 60";
      config = "zeditor ~/dotfiles";
      "sw-${hostName}" = "sudo nixos-rebuild switch --flake ~/dotfiles#${hostName}";
      "test-${hostName}" = "sudo nixos-rebuild test --flake ~/dotfiles#${hostName}";
      show-tree = "tree -a -I .git";
      vt = "cd ~/src/versustree";
      z = "zeditor .";
    };
  };
}
