{
  pkgs,
  ...
}: 
let
  monitorL = "HDMI-A-1";
  monitorC = "DP-1";
  monitorR = "DP-2";
  vr = "DP-3";
in {
  home.packages = with pkgs; [
    autotiling
    xorg.xhost
    xorg.xprop
    xorg.xrandr
  ];

  wayland.windowManager.sway = {
    enable = true;
    package = pkgs.swayfx;
    systemd.enable = true;
    xwayland = true;

    checkConfig = false; # Need this or SwayFX build freaks out
    config = {
      input = {
        "13364:353:Keychron_Keychron_Q6_Keyboard" = {
          xkb_numlock = "enable";
        };

        "1133:16514:Logitech_MX_Master_3" = {
          scroll_factor = "1.0";
        };
      };

      output = {
        "${monitorL}" = {
          pos = "0 0";
          mode = "2560x2880@60Hz";
        };
        
        "${monitorC}" = {
          pos = "2560 1440";
          mode = "3440x1440@144Hz";
        };
        
        "${monitorR}" = {
          pos = "6000 0";
          mode = "2560x2880@60Hz";
        };
        
        "${vr}" = {
          disable = "";
        };
      };

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
          { app_id = "firefox"; title = "Firefox — Sharing Indicator"; }
          { app_id = "org.gnome.Calculator"; }
          { app_id = "org.gnome.clocks"; }
          { app_id = "org.gnome.Nautilus"; }
          { app_id = "Godot"; }
          { class = "jetbrains-.*"; title = "splash"; }
          { class = "jetbrains-.*"; title = "Welcome to .*"; }
          { app_id = "org.prismlauncher.PrismLauncher"; }
          { app_id = "org.telegram.desktop"; title = "Media viewer"; }
          { class = "XIVLauncher.Core"; }
        ];
      };

      window = {
        border = 0;
        titlebar = false;
        commands = [
          {
            criteria = { app_id = "vesktop"; };
            command = "resize set width 77 ppt";
          }
          {
            criteria = { class = ".*freerdp.*"; };
            command = "floating disable";
          }
          {
            criteria = { app_id = "gamescope"; };
            command = "fullscreen enable";
          }
          {
            criteria = { class = "steam"; title = "Friends List"; };
            command = "resize set width 15 ppt";
          }
          {
            criteria = { app_id = "org.telegram.desktop"; };
            command = "resize set width 23 ppt";
          }
        ];
      };      

      assigns = {
        "1" = [
          { app_id = "btop"; }
          { class = "discord"; }
          { app_id = "vesktop"; }
          { app_id = "org.telegram.desktop"; }
        ];
        "2" = [
          { class = ".*freerdp.*"; }
        ];
        "3" = [
          { app_id = "firefox"; title = "Mozilla Firefox$"; }
        ];
        "5" = [
          { class = "ffxiv_dx11.exe"; }
          { app_id = "gamescope"; }
          { class = "steam"; }
        ];
      };

      focus = {
        mouseWarping = "output";
        followMouse = "no";
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
        { command = "xrandr --output \"${monitorC}\" --primary --preferred"; }
        { command = "waybar"; }
        # { command = "fcitx5"; }
        { command = "goxlr-daemon"; }
        { command = "gammastep -O 4500"; }
        { command = "telegram-desktop"; }
        { command = "discord.sh"; }
        { command = "nm-applet"; }
        { command = "firefox"; }
        { command = "steam"; }
        { command = "kitty --class=btop btop"; }
      ];
    };

    extraConfig = ''
      blur enable
      blur_xray disable
      blur_passes 2
      blur_radius 5
      blur_noise 0.02
      blur_brightness 0.9
      blur_contrast 0.9
      blur_saturation 1.1

      shadows enable
      shadows_on_csd disable
      shadow_blur_radius 20
      shadow_color #0000007F
      shadow_inactive_color #0000007F
      shadow_offset 0 0

      layer_effects "mako" shadows enable; blur enable; corner_radius 0
      layer_effects "rofi" shadows enable; blur enable; corner_radius 0
      layer_effects "waybar" shadows enable; blur enable; corner_radius 0
    '';
  };
}