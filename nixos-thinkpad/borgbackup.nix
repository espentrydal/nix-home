{
  services.borgbackup.jobs."thinkpad" = {
    paths = [
      "/var/lib"
      "/srv"
      "/home"
    ];
    exclude = [
      "/home/*/archive"
      "/home/*/.cache"
      "/home/*/.conda"
      "/home/*/.emacs.d"
      "/home/*/.local/share"
      "/home/*/.mozilla"
      "/home/*/.npm"
      "/home/*/src"
      "/home/*/.tmp"
      "/home/*/tmp"
      "/home/*/.vscode"
      "/home/*/.wine"
      "/home/*/fsl"

      "/var/lib/docker"
      "/var/lib/systemd"
      "/var/lib/libvirt"

      # temporary files created by cargo and `go build`
      "**/target"
      "/home/*/go/bin"
      "/home/*/go/pkg"
    ];
    repo = "zh2881@zh2881.rsync.net:thinkpad";
    encryption = {
      mode = "repokey-blake2";
      passCommand = "cat /root/borgbackup/passphrase";
    };
    environment.BORG_RSH = "ssh -i /root/.ssh/ssh_key";
    extraArgs = "--remote-path=borg1";
    compression = "auto,zstd";
    startAt = "hourly";
    prune.keep = {
      within = "1d"; # Keep all archives from the last day
      daily = 7;
      weekly = 4;
      monthly = -1;  # Keep at least one archive for each month
    };
    postPrune = "borg compact";
  };
}
