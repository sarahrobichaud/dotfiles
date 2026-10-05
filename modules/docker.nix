{
  virtualisation.docker = {
    enable = true;
  };


  users.users.zyriel.extraGroups = [ "docker" ];
}
