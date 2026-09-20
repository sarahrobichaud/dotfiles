{ pkgs, ...}:
{

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = false; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = false; # Open ports in the firewall for Source Dedicated Server
    localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
    gamescopeSession.enable = true;
  };

  hardware.xone.enable = true;


  programs.gamescope.enable = true;
  programs.gamemode.enable = true;

  qt.enable = true;


  environment.sessionVariables = {
    STEAM_EXTRA_COMPAT_TOOLS_PATHS = "/home/zyriel/.steam/root/compatibilitytools.d";
  };

  environment.systemPackages = with pkgs; [
    vscode
    protonup-ng
    uv
    kdePackages.qtdeclarative
    lutris
    lazygit
    lazydocker
    qbittorrent
    mangohud
    starship
    jellyfin-tui
    gowall
    libnatpmp
    picard
    grim
    zathura
    nodejs
    nicotine-plus
    pnpm
    vim
    wget
    neovim
    rofi
    dunst
    libnotify
    grim
    slurp
    nixd
    wl-clipboard
    pavucontrol
    guvcview
    git
    firefox
    appimage-run
    obsidian
    feishin
    discord
    texliveFull
    tree
    zed-editor-fhs
    tableplus
    gparted
    signal-desktop
    bruno
    protonmail-desktop
  ];
}
