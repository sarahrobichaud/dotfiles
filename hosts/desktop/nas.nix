{
  boot.supportedFilesystems = [ "nfs" ];

  fileSystems."/mnt/nas/media" = {
    device = "nas.local:/volume1/media";
    fsType = "nfs";
    options = [
      "x-systemd.automount"
      "noauto"
      "x-systemd.idle-timeout=600"
      "x-systemd.device-timeout=5s"
      "x-systemd.mount-timeout=5s"
    ];
  };
}
