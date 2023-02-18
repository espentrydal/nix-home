{ config, lib, pkgs, ... }:

{
  xsession.windowManager.i3 = with pkgs; {
    enable = true;
    package = i3;

    config = rec {
      modifier = "Mod4";
      bars = [ ];

      window.border = 1;

      gaps = {
        inner = 5;
        outer = 0;
      };

      keybindings = lib.mkOptionDefault {
        "XF86AudioMute" = "exec amixer set Master toggle";
        "XF86AudioLowerVolume" = "exec amixer set Master 4%-";
        "XF86AudioRaiseVolume" = "exec amixer set Master 4%+";
        "XF86MonBrightnessDown" = "exec brightnessctl set 4%-";
        "XF86MonBrightnessUp" = "exec brightnessctl set 4%+";
        "${modifier}+Return" = "exec ~/.nix-profile/bin/alacritty";
        "${modifier}+d" = "exec ${pkgs.rofi}/bin/rofi -modi drun -show drun";
        "${modifier}+Shift+d" = "exec ${pkgs.rofi}/bin/rofi -show window";
        "${modifier}+Shift+Return" = "exec ${pkgs.firefox}/bin/firefox";
        "${modifier}+Shift+x" = "exec systemctl suspend";

        "${modifier}+Shift+q" = "kill";
        #"${modifier}+Space" = "exec --no-startup-id dmenu_run";
        "${modifier}+h" = "focus left";
        "${modifier}+j" = "focus down";
        "${modifier}+k" = "focus up";
        "${modifier}+l" = "focus right";
        "${modifier}+Shift+h" = "move left";
        "${modifier}+Shift+j" = "move down";
        "${modifier}+Shift+k" = "move up";
        "${modifier}+Shift+l" = "move right";

        # Keyboard layout
        "${modifier}+ctrl+space" = "exec ~/bin/i3-keyboard-layout cycle no us";

      };

      startup = [
        {
          command = "i3-msg workspace 1";
          always = true;
          notification = false;
        }
        {
          command = "systemctl --user restart polybar.service";
          always = true;
          notification = false;
        }
        {
          command = "${pkgs.feh}/bin/feh --bg-scale ~/linux-home/nixos/machine/x11/vineyard.jpg";
          always = true;
          notification = false;
        }
        {
          # Restore resolution
          command = "exec xrandr --output HDMI-0 --mode 1920x1200";
          always = false;
          notification = false;
        }
        {
          command = "xss-lock --transfer-sleep-lock -- i3lock --nofork";
          always = false;
          notification = false;
        }
        {
          command = "exec nitrogen --restore";
          always = false;
          notification = false;
        }
        {
          command = "setxkbmap -option ctrl:nocaps";
          always = false;
          notification = false;
        }
        {
          command = "xfce4-power-manager";
          always = false;
          notification = false;
        }
        {
          command = "nm-applet";
          always = false;
          notification = false;
        }

      ];
    };
  };
}
