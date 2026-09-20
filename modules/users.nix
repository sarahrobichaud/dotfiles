{ pkgs, ...}:
{
  users.users."zyriel" = {
    isNormalUser = true;
    description = "Zyriel";
    extraGroups = [ "networkmanager" "wheel" ];
    shell = pkgs.bash;
  };
}
