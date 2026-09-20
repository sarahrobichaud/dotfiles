{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    wget
    tree
    libnatpmp
    gowall
    gparted
    kdePackages.qtdeclarative
  ];
}
