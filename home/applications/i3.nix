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

  xsession.windowManager.i3 = {
    enable = true;
    package = pkgs.i3-gaps;

    config = {
      gaps = {
        inner = 10;
        # outer = 5;
      };

      bars = [ ];
      colors = { };
      modes = { };

      workspaceOutputAssign = [
        { workspace = "1"; output = monitorL; }
        { workspace = "4"; output = monitorL; }
        { workspace = "7"; output = monitorL; }
        { workspace = "2"; output = monitorC; }
        { workspace = "5"; output = monitorC; }
        { workspace = "8"; output = monitorC; }
        { workspace = "3"; output = monitorR; }
        { workspace = "6"; output = monitorR; }
        { workspace = "9"; output = monitorR; }
      ];

      floating = {
        border = 0;
        titlebar = false;
        modifier = "Mod4";
        criteria = [
          { class = "explorer.exe"; title = "Wine System Tray"; }
          { class = "firefox"; title = "Firefox — Sharing Indicator"; }
          { class = "org.gnome.Calculator"; }
          { class = "org.gnome.clocks"; }
          { class = "org.gnome.Nautilus"; }
          { class = "Godot"; }
          { class = "jetbrains-.*"; title = "splash"; }
          { class = "jetbrains-.*"; title = "Welcome to .*"; }
          { class = "org.prismlauncher.PrismLauncher"; }
          { class = "org.telegram.desktop"; title = "Media viewer"; }
          { class = "Viewnior"; }
          { class = "XIVLauncher.Core"; }
        ];
      };

      window = {
        border = 0;
        titlebar = false;
        commands = [
          {
            criteria = { class = "(vesktop)|(discord)"; };
            command = "resize set width 77 ppt";
          }
          {
            criteria = { class = ".*freerdp.*"; };
            command = "floating disable";
          }
          {
            criteria = { class = "gamescope"; };
            command = "fullscreen enable";
          }
          {
            criteria = { class = "steam"; title = "Friends List"; };
            command = "resize set width 15 ppt";
          }
          {
            criteria = { class = "org.telegram.desktop"; };
            command = "resize set width 23 ppt";
          }
          {
            criteria = { class = "Viewnior"; };
            command = "resize set 1280 720";
          }
        ];
      };      

      assigns = {
        "1" = [
          { class = "btop"; }
          { class = "discord"; }
          { class = "vesktop"; }
          { class = "org.telegram.desktop"; }
        ];
        "2" = [
          { class = ".*freerdp.*"; }
        ];
        "3" = [
          { class = "firefox"; title = "Mozilla Firefox$"; }
        ];
        "5" = [
          { class = "ffxiv_dx11.exe"; }
          { class = "gamescope"; }
          { class = "steam"; }
        ];
      };

      focus = {
        mouseWarping = false;
        followMouse = false;
        newWindow = "none";
      };

      keybindings = {
        "Alt+F4" = "kill";
        "Alt+shift+F4" = "exec sway-kill-current-window.sh";
        "Mod4+L" = "exec hyprlock";
        "Mod4+F" = "fullscreen toggle";
        "Mod4+Space" = "floating toggle";

        "Mod4+Return" = "exec kitty";
        "Mod4+D" = "exec \"rofi -modi drun,run -show run -m ${monitorC}\"";
        "Mod4+Escape" = "exec rofi-powermenu.sh";
        "Mod4+E" = "exec nautilus";

        "Print" = "exec screenshot-sway.sh all";
        "Shift+Print" = "exec screenshot-sway.sh selection";
        "Alt+Print" = "exec screenshot-sway.sh window";
        "Ctrl+Print" = "exec screenshot-sway.sh video";

        # "XF86AudioRaiseVolume" = "";
        # "XF86AudioLowerVolume" = "";
        # "XF86AudioMute" = "";
        # "XF86AudioMicMute" = "";
        "XF86AudioPlay" = "exec media-control-with-cooldown.sh toggle";
        "XF86AudioPrev" = "exec media-control-with-cooldown.sh cdprev";
        "XF86AudioNext" = "exec media-control-with-cooldown.sh next";
        "XF86AudioStop" = "exec mpc-toggle-random.sh";

        "Mod4+KP_End" = "workspace number 1";
        "Mod4+KP_Down" = "workspace number 2";
        "Mod4+KP_Next" = "workspace number 3";
        "Mod4+KP_Left" = "workspace number 4";
        "Mod4+KP_Begin" = "workspace number 5";
        "Mod4+KP_Right" = "workspace number 6";
        "Mod4+KP_Home" = "workspace number 7";
        "Mod4+KP_Up" = "workspace number 8";
        "Mod4+KP_Prior" = "workspace number 9";

        "Mod4+Shift+KP_End" = "move container to workspace number 1";
        "Mod4+Shift+KP_Down" = "move container to workspace number 2";
        "Mod4+Shift+KP_Next" = "move container to workspace number 3";
        "Mod4+Shift+KP_Left" = "move container to workspace number 4";
        "Mod4+Shift+KP_Begin" = "move container to workspace number 5";
        "Mod4+Shift+KP_Right" = "move container to workspace number 6";
        "Mod4+Shift+KP_Home" = "move container to workspace number 7";
        "Mod4+Shift+KP_Up" = "move container to workspace number 8";
        "Mod4+Shift+KP_Prior" = "move container to workspace number 9";
      };

      startup = [
        { command = "autotiling"; }
        # { command = "fcitx5"; }
        { command = "gammastep -O 4500"; }
        { command = "telegram-desktop"; }
        { command = "discord.sh"; }
        { command = "nm-applet"; }
        { command = "firefox"; }
        { command = "steam"; }
        { command = "kitty --class=btop btop"; }
      ];
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