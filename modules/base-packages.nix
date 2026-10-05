{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    wget
    tree
    jq
    libnatpmp
    gowall
    gotop
    gparted
    kdePackages.qtdeclarative
  ];
}
