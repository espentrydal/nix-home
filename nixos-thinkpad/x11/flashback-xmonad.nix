{ pkgs, ... }: {

  # xsession.windowManager.xmonad = {
  #   enable = true;
  #   enableContribAndExtras = true;
  #   config = ./x11/xmonad.hs;
  # };

  services.xserver = {
    enable = true;
    # displayManager = {
    #   defaultSession = "xfce+xmonad";
    # };
    desktopManager = {
      xterm.enable = false;
      xfce = {
        enable = true;
        noDesktop = true;
        enableXfwm = false;
      };
    };
    windowManager.xmonad = {
      enable = true;
      enableContribAndExtras = true;
      extraPackages = haskellPackages: [
        haskellPackages.dbus
        haskellPackages.List
        haskellPackages.monad-logger
        haskellPackages.xmonad
        haskellPackages.xmonad-utils
        haskellPackages.DescriptiveKeys
      ];
    };
  };

}
