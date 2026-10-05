{ config, pkgs, ...}:
let
  wgPostUp = pkgs.writeShellScript "wg0-postup" ''
    for i in $(seq 1 30); do
      ${pkgs.iproute2}/bin/ip link show tailscale0 >/dev/null 2>&1 && break
      ${pkgs.coreutils}/bin/sleep 1
    done
    ${pkgs.iproute2}/bin/ip route add "$(cat /run/secrets/lan/subnet)" dev enp12s0 table main || true
    ${pkgs.iproute2}/bin/ip route add 100.64.0.0/10 dev tailscale0 table main || true
  '';

  wgPreDown = pkgs.writeShellScript "wg0-predown" ''
    ${pkgs.iproute2}/bin/ip route del "$(cat /run/secrets/lan/subnet)" dev enp12s0 table main || true
    ${pkgs.iproute2}/bin/ip route del 100.64.0.0/10 dev tailscale0 table main || true
  '';
in
{
  security.polkit.extraConfig = ''
    polkit.addRule(function(action, subject) {
      if (action.id == "org.freedesktop.systemd1.manage-units" &&
          action.lookup("unit") == "wg-quick-wg0.service" &&
          subject.isInGroup("wheel")) {
        return polkit.Result.YES;
      }
    });
  '';

  # NM owns the NIC: address/gateway via DHCP, DNS forced to the LAN resolver
  # from the sops-rendered profile below (DHCP's DNS is ignored).
  networking = {
    hostName = config.dotfiles.hostName;
    networkmanager.enable = true;
    wg-quick.interfaces.wg0.configFile = config.sops.templates."wg0.conf".path;
    firewall.trustedInterfaces = [ "wg0" ];
  };

  # Rendered at activation from sops secrets; consumed by wg-quick via configFile.
  sops.secrets."wireguard/private_key" = { };
  sops.secrets."wireguard/endpoint" = { };
  sops.secrets."lan/dns" = { };
  sops.secrets."lan/subnet" = { };

  # LAN resolver as device-side DNS: NM profile rendered from sops into NM's
  # keyfile dir (volatile /run, so it's re-rendered every boot). DHCP still
  # provides the address; only DNS is overridden. autoconnect-priority beats
  # NM's auto-generated "Wired connection 1" profile.
  sops.templates."enp12s0" = {
    path = "/run/NetworkManager/system-connections/enp12s0.nmconnection";
    content = ''
      [connection]
      id=enp12s0
      type=ethernet
      interface-name=enp12s0
      autoconnect=true
      autoconnect-priority=100
      # Keep resolved from diverting .local names (e.g. nas.local) into
      # multicast mDNS — they must go to the LAN resolver as unicast DNS.
      mdns=0

      [ipv4]
      method=auto
      ignore-auto-dns=true
      dns=${config.sops.placeholder."lan/dns"};
      # Route nas.local to the LAN resolver even while wg0's "~." routing
      # domain is capturing everything else for the full-tunnel VPN.
      dns-search=nas.local;

      [ipv6]
      method=auto
    '';
    owner = "root";
    mode = "0600";
    restartUnits = [ "NetworkManager.service" ];
  };

  sops.templates."wg0.conf" = {
    content = ''
      [Interface]
      Address = 10.2.0.2/32
      DNS = 10.2.0.1
      PrivateKey = ${config.sops.placeholder."wireguard/private_key"}
      PostUp = ${wgPostUp}
      PreDown = ${wgPreDown}

      [Peer]
      PublicKey = yDABIIjKHTfyA+J+cuHetkq2G6u+9yiRh3OsEEPS01M=
      AllowedIPs = 0.0.0.0/0
      Endpoint = ${config.sops.placeholder."wireguard/endpoint"}
    '';
    owner = "root";
    mode = "0400";
    restartUnits = [ "wg-quick-wg0.service" ];
  };

  systemd.services.wg-quick-wg0 = {
    after = [ "tailscaled.service" ];
    wants = [ "tailscaled.service" ];
  };

  services.tailscale.enable = true;

  systemd.services.reset-ethernet-r8169 = {
    description = "Reset ethernet on wake from sleep";
    wantedBy = [ "post-resume.target" ];
    after = [ "post-resume.target" ];
    script = ''
      /run/current-system/sw/bin/modprobe -r r8169
      /run/current-system/sw/bin/modprobe -i r8169
      /run/current-system/sw/bin/systemctl restart NetworkManager
    '';
  };
}
