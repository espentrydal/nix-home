{ pkgs, ... }:
{

  #
  # Networking
  #

  # Adblock
  networking.extraHosts = let
    hostsPath = https://raw.githubusercontent.com/StevenBlack/hosts/master/alternates/fakenews-gambling-porn/hosts;
    hostsFile = builtins.fetchurl hostsPath;
  in builtins.readFile "${hostsFile}";

  # NetworkManager
  networking.networkmanager.enable = true;
  systemd.services.NetworkManager-wait-online.enable = false;

  # Firewall
  networking.firewall.allowedUDPPorts = [
    22
    41641
  ];
  networking.firewall.allowedTCPPorts = [ 22 ];
  networking.firewall.checkReversePath = "loose";

  # OpenSSH
  services.openssh = {
    enable = true;
    passwordAuthentication = false;
    permitRootLogin = "no";
    forwardX11 = true;
  };
  # Mosh
  programs.mosh.enable = true;
  # Tailscale
  services.tailscale.enable = true;

  # Avahi
  services.avahi = {
    enable = true;
    nssmdns = true;
    publish = {
      enable = true;
      addresses = true;
      workstation = true;
    };
  };

}
