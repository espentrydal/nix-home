{ config, pkgs, ... }:

{
  services.xserver = {
    enable = true;
    # FIXME this works for WM and chrome, but does not seem to work for xterm and
    # urxvt. Thus I'm currently still using .Xresources
    #services.xserver.dpi = 144;

    displayManager = {
      gdm.enable = true;
      autoLogin.enable = false;
      autoLogin.user = "espen";
      defaultSession = "xfce+i3";
    };

    desktopManager = {
      gnome.enable = true;
      xfce = {
        enable = true;
        noDesktop = true;
        enableXfwm = false;
      };
    };

    windowManager.i3 = with pkgs; {
      enable = true;
      package = i3-gaps;
    };

    layout = "no";
    xkbVariant = "";
    extraLayouts = {
      Tyndale-il = {
        description = "Hebrew (Tyndale)";
        languages = [ "il" ];
        symbolsFile = ../../pkgs/xkb/Tyndale-il.xkb;
      };
      Tyndale-gr = {
        description = "Greek (Tyndale)";
        languages = [ "gr" ];
        symbolsFile = ../../pkgs/xkb/Tyndale-gr.xkb;
      };
    };

    # Enable touchpad support.
    libinput = {
      enable = true;
      touchpad.naturalScrolling = true;
      mouse.naturalScrolling = true;
    };
    inputClassSections = [
      ''
        Identifier "natural scrolling"
        MatchIsPointer "on"
        Option "NaturalScrolling" "on"
      ''
    ];

  };

  # services.xserver.windowManager.i3.extraPackages = with pkgs; [
  #    rofi i3status playerctl
  #    (python37.withPackages(ps:
  #      [ (ps.toPythonModule (i3pystatus.override { python3Packages = ps; })) ]))
  # ];

  services.dbus.packages = [ pkgs.dconf ];

  # Configure keymap in X11
  services.xserver = {
  };

  # Workaround for GNOME autologin: https://github.com/NixOS/nixpkgs/issues/103746#issuecomment-945091229
  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;

  # THus, I'm manually sourcing ~/.profile before starting the display manager
  #services.xserver.displayManager.sessionCommands = "source $HOME/.profile";

  qt5.enable = true;
  qt5.platformTheme = "gtk2";
  qt5.style = "gtk2";

}
