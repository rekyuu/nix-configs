{
  lib,
  pkgs,
  ...
}:
let
  monitorL = "HDMI-A-1";
  monitorC = "DP-1";
  monitorR = "DP-2";

  # on = event: body: {
  #   _args = [
  #     event
  #     (lib.generators.mkLuaInline ''function() ${body} end'')
  #   ];
  # };
  # exec = cmd: ''hl.exec_cmd("${cmd}")'';
in {
  home.packages = with pkgs; [
    grim
    slurp
    wf-recorder
    wl-clipboard
    xhost
    xprop
    xrandr
  ];

  home.sessionVariables = {
    QT_QPA_PLATFORM = "wayland;xcb";
    GDK_BACKEND = "wayland,x11";
    NIXOS_OZONE_WL = "1";
  };

  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;
    systemd.variables = ["--all"];
    configType = "hyprlang"; # TODO: will need to be converted to "lua"

    settings = {
      monitor = [
        "${monitorL}, 2560x2880@60, 0x0, 1"
        "${monitorC}, 3440x1440@144, 2560x1440, 1"
        "${monitorR}, 2560x2880@60, 6000x0, 1"
      ];

      input = {
        kb_layout = "us";
        numlock_by_default = true;
        repeat_delay = 250;
        follow_mouse = 2;
        sensitivity = 0;
      };

      general = {
        gaps_in = 5;
        gaps_out = 10;
        border_size = 0;
        # "col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
        # "col.inactive_border" = "rgba(595959aa)";
        layout = "dwindle";
      };

      decoration = {
        rounding = 0;

        shadow = {
          enabled = true;
          range = 20;
          render_power = 5;
          color = "0x1a1a1a55";
        };
      };

      animations = {
        enabled = "yes";
        animation = [
          "windows, 1, 3, default"
          "windowsOut, 1, 3, default, popin 80%"
          "border, 1, 3, default"
          "borderangle, 1, 3, default"
          "fade, 1, 3, default"
          "workspaces, 1, 3, default, slidevert"
        ];
      };

      dwindle = {
        preserve_split = true;
        force_split = 2;
      };

      misc = {
        disable_hyprland_logo = true;
        disable_splash_rendering = true;
        disable_autoreload = false;
      };

      cursor = {
        warp_on_change_workspace = true;
      };

      workspace = [
        "name:1, monitor:${monitorL}"
        "name:4, monitor:${monitorL}"
        "name:7, monitor:${monitorL}"

        "name:2, monitor:${monitorC}"
        "name:5, monitor:${monitorC}"
        "name:8, monitor:${monitorC}"

        "name:3, monitor:${monitorR}"
        "name:6, monitor:${monitorR}"
        "name:9, monitor:${monitorR}"
      ];

      window_rule = [
        # Floating windows
        # ----------------------------------------------------------------
        "float, class:explorer.exe, title:Wine System Tray"
        "float, class:firefox, title:Firefox — Sharing Indicator"
        "float, class:org.gnome.Calculator"
        "float, class:org.gnome.clocks"
        "float, class:org.gnome.Nautilus"
        "float, class:Godot"
        "float, class:jetbrains-.*, title:splash"
        "float, class:jetbrains-.*, title:Welcome to .*"
        "float, class:moe.launcher..*-launcher"
        "float, class:org.telegram.desktop, title:Media viewer"
        "float, class:pol.exe" # PlayOnline
        "float, class:steam_app_0, title:CatseyeXI"
        "float, class:Viewnior"
        "float, class:XIVLauncher.Core"

        # Window rules
        # ----------------------------------------------------------------
        "tile, class:.*freerdp.*"
        "fullscreen, class:gamescope"
        "center, class:Rofi"
        "stayfocused, class:Rofi"
        "center, class:Viewnior"
        "size 1280 720, class:Viewnior"

        # Workspace assignments
        # ----------------------------------------------------------------
        # "monitor ${monitorC}, class:Rofi"

        # Workspace 7
        "workspace 7, class:btop"
        "workspace 7, class:(discord)|(vesktop)"
        "workspace 7, class:org.telegram.desktop"

        # Workspace 8
        "workspace 8, class:.*freerdp.*"

        # Workspace 9
        "workspace 9, class:firefox, title: Mozilla Firefox$"

        # Workspace 5
        "workspace 5, class:ffxiv_dx11.exe"
        "workspace 5, class:gamescope"
        "workspace 5, class:org.libretro.RetroArch"
        "workspace 5, class:steam"
      ];

      bindm = [
        "SUPER, mouse:272, movewindow"
        "SUPER, mouse:273, resizewindow"
      ];

      bind = [
        "ALT, F4, killactive"
        "ALT SHIFT, F4, exec, hyprland-kill-current-window.sh"
        "SUPER, L, exec, hyprlock"
        "SUPER, F, fullscreen"
        "SUPER, SPACE, togglefloating"
        "SUPER, S, exec, rofi-screenshot-menu.sh"

        "SUPER, Return, exec, kitty"
        "SUPER, D, exec, rofi -modi drun,run -show run -m ${monitorC}"
        "SUPER, Escape, exec, rofi-power-menu.sh"
        "SUPER, E, exec, nautilus"

        ", Print, exec, screenshot-hyprland.sh desktop"
        "SHIFT, Print, exec, screenshot-hyprland.sh selection"
        "ALT, Print, exec, screenshot-hyprland.sh active-window"
        "CTRL, Print, exec, screenshot-hyprland.sh selection-video"

        # ", XF86AudioRaiseVolume, exec, "
        # ", XF86AudioLowerVolume, exec, "
        # ", XF86AudioMute, exec, "
        # ", XF86AudioMicMute, exec, "
        ", XF86AudioPlay, exec, media-control-with-cooldown.sh toggle"
        ", XF86AudioPrev, exec, media-control-with-cooldown.sh cdprev"
        ", XF86AudioNext, exec, media-control-with-cooldown.sh next"
        ", XF86AudioStop, exec, mpc-toggle-random.sh"

        # Standard
        # "SUPER, KP_End, workspace, 1"
        # "SUPER, KP_Down, workspace, 2"
        # "SUPER, KP_Next, workspace, 3"
        # "SUPER, KP_Left, workspace, 4"
        # "SUPER, KP_Begin, workspace, 5"
        # "SUPER, KP_Right, workspace, 6"
        # "SUPER, KP_Home, workspace, 7"
        # "SUPER, KP_Up, workspace, 8"
        # "SUPER, KP_Prior, workspace, 9"

        # Reversed
        "SUPER, KP_End, workspace, 7"
        "SUPER, KP_Down, workspace, 8"
        "SUPER, KP_Next, workspace, 9"
        "SUPER, KP_Left, workspace, 4"
        "SUPER, KP_Begin, workspace, 5"
        "SUPER, KP_Right, workspace, 6"
        "SUPER, KP_Home, workspace, 1"
        "SUPER, KP_Up, workspace, 2"
        "SUPER, KP_Prior, workspace, 3"

        # Standard
        # "SUPER SHIFT, KP_End, movetoworkspacesilent, 1"
        # "SUPER SHIFT, KP_Down, movetoworkspacesilent, 2"
        # "SUPER SHIFT, KP_Next, movetoworkspacesilent, 3"
        # "SUPER SHIFT, KP_Left, movetoworkspacesilent, 4"
        # "SUPER SHIFT, KP_Begin, movetoworkspacesilent, 5"
        # "SUPER SHIFT, KP_Right, movetoworkspacesilent, 6"
        # "SUPER SHIFT, KP_Home, movetoworkspacesilent, 7"
        # "SUPER SHIFT, KP_Up, movetoworkspacesilent, 8"
        # "SUPER SHIFT, KP_Prior, movetoworkspacesilent, 9"

        # Reversed
        "SUPER SHIFT, KP_End, movetoworkspacesilent, 7"
        "SUPER SHIFT, KP_Down, movetoworkspacesilent, 8"
        "SUPER SHIFT, KP_Next, movetoworkspacesilent, 9"
        "SUPER SHIFT, KP_Left, movetoworkspacesilent, 4"
        "SUPER SHIFT, KP_Begin, movetoworkspacesilent, 5"
        "SUPER SHIFT, KP_Right, movetoworkspacesilent, 6"
        "SUPER SHIFT, KP_Home, movetoworkspacesilent, 1"
        "SUPER SHIFT, KP_Up, movetoworkspacesilent, 2"
        "SUPER SHIFT, KP_Prior, movetoworkspacesilent, 3"
      ];

      # on = [
      #   (on "hyprland.start" ''
      #     ${exec "xrandr --output \\\"${monitorC}\\\" --primary --preferred"}
      #     ${exec "xdg-portal-init.sh"}
      #     ${exec "waybar"}
      #     ${exec "waypaper --restore"}
      #     ${exec "gammastep -O 4500"}
      #     ${exec "fcitx5 -d -r"}
      #     ${exec "Telegram"}
      #     ${exec "discord.sh"}
      #     ${exec "nm-applet"}
      #     ${exec "firefox"}
      #     ${exec "steam"}
      #     ${exec "kitty --class=btop btop"}
      #   '')
      # ];

      exec-once = [
        "xrandr --output \"${monitorC}\" --primary --preferred"
        "xdg-portal-init.sh"
        "waybar"
        "waypaper --restore"
        "gammastep -O 4500"
        "fcitx5 -d -r"
        "Telegram"
        "discord.sh"
        "nm-applet"
        "firefox"
        "steam"
        "kitty --class=btop btop"
      ];
    };
  };
}