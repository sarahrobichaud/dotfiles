{
  virtualisation.docker = {
    enable = true;

    # rootless = {
    #   enable = true;
    #   setSocketVariable = true;
    # };
  };


  # Optional: Add your user to the "docker" group to run docker without sudo
  users.users.zyriel.extraGroups = [ "docker" ];
}
