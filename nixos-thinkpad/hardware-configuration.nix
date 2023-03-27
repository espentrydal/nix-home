{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "nvme" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/6abb4592-125d-401b-a60d-27732ab33a56";
      fsType = "ext4";
    };

  boot.initrd.luks.devices."luks-815a900c-d040-4808-bcd0-422bd62e3322".device = "/dev/disk/by-uuid/815a900c-d040-4808-bcd0-422bd62e3322";

  fileSystems."/boot/efi" =
    { device = "/dev/disk/by-uuid/012E-2672";
      fsType = "vfat";
    };

  swapDevices =
    [ { device = "/dev/disk/by-uuid/871a35c8-5c6d-4048-9192-94161f6c7965"; }
    ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp0s31f6.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp0s20f3.useDHCP = lib.mkDefault true;

  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  hardware.opengl.driSupport32Bit = true;
  hardware.pulseaudio.support32Bit = true;

}
