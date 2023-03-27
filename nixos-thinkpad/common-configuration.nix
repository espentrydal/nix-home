# Common nixos configuration for thinkpad, mainframe, macbook and raspberry pi

{ config, lib, pkgs, ... }:

let
  unstableTarball =
    fetchTarball
      https://github.com/NixOS/nixpkgs/archive/nixos-unstable.tar.gz;
in {

  #
  # User. Don't forget to set a password with ‘passwd’.
  #
  users.users.espen = {
    isNormalUser = true;
    home = "/home/espen";
    description = "Espen Trydal";
    extraGroups = [ "networkmanager" "wheel" ];
    uid = 1000;
    shell = pkgs.zsh;
    openssh.authorizedKeys.keys = [
    # This is my public key
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDAiaiBQhGCjeFk8EyRFN+pLSxHqNUQNpx8rP3SxqzA+fpTho/pkq+QqoTt0m2qXlmA2KKJQ9ai2uGAm+iiPmRc3908YS91kL9NjpBvlsyakBAWU366GTAZU1oSQHnshSZnJplyKt5gNMbXQMLHWnlWIr9co3jL8KAI+XNnP8ZrwTMSneK8LPhWYp/NldYH1cazEWTagYoTy9NuUrug1wGkmepCR3bY1I+NbFmsFZtYt4YVA9KUvTuTrR1uvirRn4YQdBMfuYXQIPkAVtBRpk0N1EXC2PnOex3tr5h30VcIJCKYqaYhw7Q9lZP/K97+IzfMv1HD7ei8RZc2BR5KcJUkgvmTBwy0os5WlwbJ32qzJulv8kaZ02IQOpo+zK/g+qH9P1IYiSRMFR796t0V2lFH67+hSfNKLWvQ6gnIDZAnkecJ05moSQ+djFnc7n7H4yncNQ+GegxQeOlMyZnzppMAeZ4i4maz83ri8kk88uDWNekJgDREVhkDiMLHfw+cChc= espen@thinkpad-nixos"
    ];
  };

  environment.shellAliases = {
    l = "ls -la";
    la = "ls -a";
    ll = "ls -l";
    vi = "nvim";
    e = "emacsclient -nw";
  };

  #
  # Locale
  #
  time.timeZone = "Europe/Oslo";
  i18n.defaultLocale = "en_US.utf8";
  console.keyMap = "no";

  # Default fonts
  fonts.enableDefaultFonts = lib.mkDefault true;

  #
  # Security
  #
  # unlock gpg keys with my login password
  # security.pam.services.login.gnupg.enable = true;
  # security.pam.services.login.gnupg.noAutostart = true;
  # security.pam.services.login.gnupg.storeOnly = true;
  # security.pam.services.lightdm-greeter.gnupg.enable = true;
  # security.pam.services.lightdm-greeter.gnupg.noAutostart = true;
  # security.pam.services.lightdm-greeter.gnupg.storeOnly = true;
  # security.pam.services.i3lock.gnupg.enable = true;
  # security.pam.services.i3lock.gnupg.noAutostart = true;

  #
  # Nix
  #
  system.autoUpgrade = {
    channel = lib.mkDefault "https://nixos.org/channels/nixos-22.11/";
    enable = true;
    allowReboot = lib.mkDefault false;
  };

  nix = {
    # machine specific configuration in nixos/machine/$hostname/
    nixPath = [
      "nixpkgs=/nix/var/nix/profiles/per-user/root/channels/nixos"
      "nixos-config=/home/espen/linux-home/nixos/machine/${config.networking.hostName}/configuration.nix" ];

    settings.trusted-users = [ "root" "espen" ];

    package = pkgs.nixFlakes;
    gc.automatic = true;
    gc.dates =  "weekly";

    extraOptions = ''
                 keep-outputs = true
                 keep-derivations = true

                 experimental-features = nix-command flakes
                 tarball-ttl = 0
                 narinfo-cache-negative-ttl = 0
                 narinfo-cache-positive-ttl = 0
                 '';
  };
  nixpkgs.config = {
    allowUnfree = true;
    packageOverrides = pkgs: {
      unstable = import unstableTarball {
        config = config.nixpkgs.config;
      };
    };
    tarball-ttl = 0;
    tarballTtl = 0;
  };

  #
  # Compatibility
  #

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.mtr.enable = true;

  system.activationScripts.ldso = lib.stringAfter [ "usrbinenv" ] ''
    mkdir -m 0755 -p /lib64
    ln -sfn ${pkgs.glibc.out}/lib64/ld-linux-x86-64.so.2 /lib64/ld-linux-x86-64.so.2.tmp
    mv -f /lib64/ld-linux-x86-64.so.2.tmp /lib64/ld-linux-x86-64.so.2 # atomically replace
  '';

  services.udev.extraRules = '' ACTION=="add", SUBSYSTEMS=="usb", SUBSYSTEM=="block", ENV{ID_FS_USAGE}=="filesystem", RUN{program}+="${pkgs.systemd}/bin/systemd-mount --no-block --automount=yes --collect $devnode /media" '';

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.05"; # Did you read the comment?

}

