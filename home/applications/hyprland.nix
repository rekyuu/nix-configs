{
  inputs,
  pkgs,
  ...
}: 
let
  monitorL = "HDMI-A-1";
  monitorC = "DP-1";
  monitorR = "DP-2";
  vr = "DP-3";
in
{
  imports = [inputs.hyprland.homeManagerModules.default];

  home.packages = with pkgs; [
    xorg.xhost
    xorg.xprop
    xorg.xrandr
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    systemd.variables = ["--all"];
    
    settings = {
      monitor = [
        "${monitorL}, 2560x2880@60, 0x0, 1"
        "${monitorC}, 3440x1440@144, 2560x1440, 1"
        "${monitorR}, 2560x2880@60, 6000x0, 1"
        "${vr}, disable"
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
        "col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
        "col.inactive_border" = "rgba(595959aa)";
        layout = "dwindle";
      };

      decoration = {
        rounding = 0;
        drop_shadow = "yes";
        shadow_range = 20;
        shadow_render_power = 5;
        "col.shadow" = "rgba(1a1a1a55)";
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
        pseudotile = true;
        preserve_split = true;
        force_split = 2;
      };

      gestures = {
        workspace_swipe = "off";
      };

      misc = {
        disable_hyprland_logo = true;
        disable_splash_rendering = true;
        disable_autoreload = false;
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

      windowrulev2 = [
        # Window rules
        # ----------------------------------------------------------------
        "float, class:^(Anamnesis.exe)$"
        "float, class:^(blender)$, title:^(Blender Render)$"
        "float, class:^(blender)$, title:^(Blender Preferences)$"
        "float, class:^(org.corectrl.corectrl)$"
        "center, class:^(org.corectrl.corectrl)$"
        "float, class:^(explorer.exe)$, title:^(Wine System Tray)$"
        "noanim, class:^(feh)$"
        "float, class:^(firefox)$, title:^(Firefox — Sharing Indicator)$"
        "tile, class:^(.*freerdp.*)$"
        "float, class:^(galculator)$"
        "float, class:^(gnome-pomodoro)$"
        "float, class:^(Godot.*)$"
        "float, class:^(mpv)$"
        "float, class:^(org.gnome.Calculator)$"
        "float, class:^(org.gnome.clocks)$"
        "float, class:^(org.gnome.Nautilus)$"
        "float, class:^(org.telegram.desktop)$, title:^(Media viewer)$"
        "float, class:^(Viewnior)$"
        "center, class:^(Viewnior)$"
        "size 1280 720, class:^(Viewnior)$"

        # JetBrains
        # https://github.com/hyprwm/Hyprland/issues/3450#issuecomment-1816761575
        "float, class:^(jetbrains-.*)$, title:^(Welcome to .*)$"
        "windowdance, class:^(jetbrains-.*)$, floating:1"
        "center, class:^(jetbrains-.*)$, title:^(splash)$, floating:1"
        "nofocus, class:^(jetbrains-.*)$, title:^(splash)$, floating:1"
        "noborder, class:^(jetbrains-.*)$, title:^(splash)$, floating:1"
        "center, class:^(jetbrains-.*)$, title:^()$, floating:1"
        "stayfocused, class:^(jetbrains-.*)$, title:^()$, floating:1"
        "noborder, class:^(jetbrains-.*)$, title:^()$, floating:1"
        "nofocus, class:^(jetbrains-.*)$, title:^(win.*)$, floating:1"

        # Godot
        "stayfocused, class:^(Godot.*)$, title:^()$, floating:1"
        "noborder, class:^(Godot.*)$, title:^()$, floating:1"

        # Games
        "fullscreen, class:^(dota2)$"
        "fullscreen, class:^(ffxiv_dx11.exe)$"
        "fullscreen, class:^(gamescope)$"
        "fullscreen, class:^(genshinimpact.exe)$"
        "float, class:^(moe.launcher.an-anime-game-launcher)$"
        "center, class:^(moe.launcher.an-anime-game-launcher)$"
        "float, class:^(moe.launcher.the-honkers-railway-launcher)$"
        "center, class:^(moe.launcher.the-honkers-railway-launcher)$"
        "fullscreen, class:^(mtga.exe)$"
        "float, class:^(XIVLauncher.Core)$"
        "center, class:^(XIVLauncher.Core)$"

        # EmoTracker
        "noblur, class:^(emotracker.exe)"
        "noshadow, class:^(emotracker.exe)"
        "noborder, class:^(emotracker.exe)"

        # Workspace assignments
        # ----------------------------------------------------------------
        "workspace 7, class:^(btop)$"
        "workspace 7, class:^(vesktop)$"
        "workspace 9, class:^(firefox)$"
        "workspace 5, class:^(steam)$"
        "workspace 5, class:^(steamwebhelper)$"
        "workspace 7, class:^(org.telegram.desktop)$"
        "workspace 8, class:(.*freerdp.*)"

        # Games
        "workspace 5, class:^(dota2)$"
        "workspace 5, class:^(ffxiv_dx11.exe)$"
        "workspace 5, class:^(gamescope)$"
        "workspace 5, class:^(genshinimpact.exe)$"
        "workspace 5, class:^(mtga.exe)$"
        # "workspace 5, class:^(org.libretro.RetroArch)$"
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

        "SUPER, Return, exec, kitty"
        "SUPER, D, exec, rofi -modi drun,run -show run -m DP-1"
        "SUPER, Escape, exec, rofi-powermenu"
        "SUPER, E, exec, nautilus"

        ", Print, exec, screenshot-hyprland.sh all"
        "SHIFT, Print, exec, screenshot-hyprland.sh selection"
        "ALT, Print, exec, screenshot-hyprland.sh window"
        "CTRL, Print, exec, screenshot-hyprland.sh video"

        ", XF86AudioRaiseVolume, exec, set-volume up"
        ", XF86AudioLowerVolume, exec, set-volume down"
        ", XF86AudioMute, exec, set-volume mute"
        ", XF86AudioMicMute, exec, pactl set-source-mute @DEFAULT_SOURCE@ toggle"
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

      exec-once = [
        "xrandr --output \"${monitorC}\" --primary --preferred"
        "dbus-update-activation-environment --systemd --all"
        "systemctl --user import-environment DISPLAY WAYLAND_DISPLAY XDG_CURRENT_DESKTOP QT_QPA_PLATFORMTHEME"
        # "mako"
        "waybar"
        # "fcitx5"
        "goxlr-daemon"
        "gammastep -O 4500"
        # "transmission-qt"
        "telegram-desktop"
        "vesktop"
        # "nm-applet"
        "firefox"
        # "steam"
        # "mpd-notify"
        "kitty --class=btop btop"
      ];
    };
  };

  programs.hyprlock = {
    enable = true;
    settings = {
      general = {
        hide_cursor = true;
      };

      background = [
        {
          monitor = monitorL;
          color = "rgba(0, 0, 0, 1.0)";
        }
        {
          monitor = monitorC;
          path = "$HOME/Pictures/wallhaven-eyk71r-no-drop-shadow-darkened-blur.png";
        }
        {
          monitor = monitorR;
          color = "rgba(0, 0, 0, 1.0)";
        }
      ];

      label = [
        {
          monitor = monitorC;

          text = "cmd[update:1000] date +\"%H:%M\"";
          text_align = "center";
          color = "rgba(200, 200, 200, 1.0)";
          font_size = 128;
          font_family = "Noto Sans Black";
          rotate = 0; # degrees, counter-clockwise

          position = "0, 20";
          halign = "center";
          valign = "center";
        }
        {
          monitor = monitorC;

          text = "cmd[update:1000] date +\"%A, %B %e, %Y\"";
          text_align = "center";
          color = "rgba(200, 200, 200, 1.0)";
          font_size = 32;
          font_family = "Noto Sans ExtraLight";
          rotate = 0; # degrees, counter-clockwise

          position = "0, -20";
          halign = "center";
          valign = "center";
        }
      ];

      input-field = {
        monitor = monitorC;

        size = "480, 64";
        outline_thickness = 3;
        # Scale of input-field height, 0.2 - 0.8
        dots_size = 0.33;
        # Scale of dots' absolute size, 0.0 - 1.0
        dots_spacing = 0.15; 
        dots_center = false;
        # -1 default circle, -2 follow input-field rounding
        dots_rounding = -1;
        outer_color = "rgb(151515)";
        inner_color = "rgb(200, 200, 200)";
        font_color = "rgb(10, 10, 10)";
        fade_on_empty = true;
        # Milliseconds before fade_on_empty is triggered.
        fade_timeout = 1000;
        # Text rendered in the input box when it's empty.
        placeholder_text = "<i>Input Password...</i>";
        hide_input = false;
        # -1 means complete rounding (circle/oval)
        rounding = -1;
        check_color = "rgb(204, 136, 34)";
        # if authentication failed, changes outer_color and fail message color
        fail_color = "rgb(204, 34, 34)";
        # can be set to empty
        fail_text = "<i>$FAIL <b>($ATTEMPTS)</b></i>";
        # transition time in ms between normal outer_color and fail_color
        fail_transition = 300;
        capslock_color = -1;
        numlock_color = -1;
        # when both locks are active. -1 means don't change outer color (same for above)
        bothlock_color = -1; 
        # change color if numlock is off
        invert_numlock = false; 
        # see below
        swap_font_color = false; 

        position = "0, -100";
        halign = "center";
        valign = "center";
      };
    };
  };

  services.hyprpaper = {
    enable = true;
    settings = {
      preload = ["~/Pictures/wallhaven-zxvkmy.jpg"];
      wallpaper = [
        "${monitorL},~/Pictures/wallhaven-zxvkmy.jpg"
        "${monitorC},~/Pictures/wallhaven-zxvkmy.jpg"
        "${monitorR},~/Pictures/wallhaven-zxvkmy.jpg"
      ];
    };
  };

  services.hypridle = {
    enable = true;
    settings = {
      general = {
        lock_cmd = "pidof hyprlock || hyprlock";
        before_sleep_cmd = "loginctl lock-session";
        after_sleep_cmd = "hyprctl dispatch dpms on";
      };

      listener = [
        {
          timeout = 300;
          on-timeout = "loginctl lock-session";
        }
        {
          timeout = 600;
          on-timeout = "hyprctl dispatch dpms off && pkill gammastep";
          on-resume = "hyprctl dispatch dpms on && gammastep -O 4500";
        }
      ];
    };
  };
}