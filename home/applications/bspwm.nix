{
  pkgs,
  ...
}: 
let
  monitorL = "HDMI-A-0";
  monitorC = "DisplayPort-0";
  monitorR = "DisplayPort-1";
  vr = "DisplayPort-2";
in {
  home.packages = with pkgs; [
    dunst
    picom
    polybar
  ];

  xsession.windowManager.bspwm= {
    enable = true;

    monitors = {
      "${monitorL}" = [ "1" "4" "7" ];
      "${monitorC}" = [ "2" "5" "8" ];        
      "${monitorR}" = [ "3" "6" "9" ];
    };

    settings = {
      pointer_modifier = "mod4";
      pointer_action1 = "move";
      pointer_action2 = "resize_side";
      pointer_action3 = "resize_corner";
      border_width = 0;
      window_gap = 10;
      ignore_ewmh_focus = "true";
      split_ratio = 0.5;
      borderless_monocle = "false";
      gapless_monocle = "false";
    };

    rules = {
      "TelegramDesktop" = {
        desktop = "1";
        splitDir = "east";
        splitRation = "0.225";
        follow = false;
        focus = false;
      };

      "discord" = {
        desktop = "1";
        follow = false;
        focus = false;
      };

      "Steam" = {
        desktop = "5";
        follow = false;
        focus = false;
      };
    };

    startupPrograms = [
      "xrandr --output \"${monitorC}\" --primary --preferred"
      "polybar"
      # "fcitx5"
      "gammastep -O 4500"
      "telegram-desktop"
      "discord.sh"
      "nm-applet"
      "firefox"
      "steam"
      "kitty --class=btop btop"
    ];
  };

  services.sxhkd = {
    enable = true;

    keybindings = {
      "alt + {_,shift + }F4" = "bspc node -{c,k}";
      # TODO: locksreen
      # "super + l" = "";
      "super + {Space,f}" = "bspc node focused -t {\~floating,\~fullscreen}";
      "super + Return" = "kitty";
      "super + d" = "rofi -modi drun,run -show run -m ${monitorC}";
      "super + e" = "nautilus";
      "super + Escape" = "rofi-powermenu.sh";

      # TODO: screenshots

      "XF86AudioPlay" = "media-control-with-cooldown.sh toggle";
      "XF86AudioPrev" = "media-control-with-cooldown.sh cdprev";
      "XF86AudioNext" = "media-control-with-cooldown.sh next";
      "XF86AudioStop" = "mpc-toggle-random.sh";

      "super {_,shift + }KP_{End,Left,Home}" = "bspc {desktop -f,node -d} {1,4,7}";
      "super {_,shift + }KP_{Down,Begin,Up}" = "bspc {desktop -f,node -d} {2,5,8}";
      "super {_,shift + }KP_{Next,Right,Prior}" = "bspc {desktop -f,node -d} {3,6,9}";
    };
  };

  services.picom = {
    enable = true;

    fade = true;
    fadeDelta = 10;

    shadow = true;

    vSync = true;
  };
}