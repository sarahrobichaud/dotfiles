{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    wget
    tree
    libnatpmp
    gowall
    gotop
    gparted
    kdePackages.qtdeclarative
  ];
}
