{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    jellyfin-tui
    feishin
    picard
    nicotine-plus
    guvcview
  ];
}
