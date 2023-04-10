{ pkgs, ... }:

{
  imports =
    [
      ./boot.nix
      #./borgbackup.nix
      ./common-configuration.nix
      ./network-desktop.nix
      ./packages-desktop.nix
      ./x11/x11.nix
    ];

  #################### HOSTNAME ####################
  networking.hostName = "thinkpad-nixos";
  ##################################################

  #
  # Power
  #
  services.acpid.enable = true;
  powerManagement.enable = true;

  #
  # Peripherals and sound
  #

  # CUPS
  services.printing.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;
    #media-session.enable = true;
  };

}
