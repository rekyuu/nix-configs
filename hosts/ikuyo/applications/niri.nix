{
  pkgs,
  ...
}:
let
  monitorL = "HDMI-A-1";
  monitorC = "DP-1";
  monitorR = "DP-2";

  niriConfig = pkgs.writeText "niriConfig.kdl"
    ''
    input {
      keyboard {
        numlock
      }
    }

    output "${monitorL}" {
      mode "2560x2880@60"
      scale 1
      transform "normal"
      position x=0 y=0
    }

    output "${monitorC}" {
      mode "3440x1440@144"
      scale 1
      transform "normal"
      position x=2560 y=1440
    }

    output "${monitorR}" {
      mode "2560x2880@60"
      scale 1
      transform "normal"
      position x=6000 y=0
    }

    xwayland-satellite {
      path "xwayland-satellite"
    }

    layout {
      gaps 10

      // When to center a column when changing focus, options are:
      // - "never", default behavior, focusing an off-screen column will keep at the left
      //   or right edge of the screen.
      // - "always", the focused column will always be centered.
      // - "on-overflow", focusing a column will center it if it doesn't fit
      //   together with the previously focused column.
      center-focused-column "on-overflow"
      always-center-single-column true

      preset-column-widths {
        proportion 0.25
        proportion 0.33333
        proportion 0.5
        proportion 0.66667
      }

      default-column-width { proportion 0.66667; }

      focus-ring {
        off
      }

      border {
        off
      }

      shadow {
        on

        softness 30
        spread 5
        offset x=0 y=0
        color "#0007"
      }
    }

    spawn-sh-at-startup "xrandr --output \"${monitorC}\" --primary --preferred"
    spawn-at-startup "xdg-portal-init.sh"
    spawn-sh-at-startup "waypaper --restore"
    spawn-sh-at-startup "gammastep -O 4500"
    spawn-sh-at-startup "fcitx5 -d -r"
    spawn-at-startup "Telegram"
    spawn-at-startup "discord.sh"
    spawn-at-startup "nm-applet"
    spawn-at-startup "firefox"
    spawn-at-startup "steam"
    spawn-sh-at-startup "kitty --class=btop btop"
    spawn-sh-at-startup "wl-paste --type text --watch clipboard.sh"

    hotkey-overlay {
      skip-at-startup
    }

    prefer-no-csd

    screenshot-path "~/Screenshots/%Y-%m/%Y-%m-%d_%H-%M-%S.png"

    animations {
      slowdown 1.0
    }

    workspace "7" {
      open-on-output "${monitorL}"
    }

    workspace "4" {
      open-on-output "${monitorL}"
    }

    workspace "1" {
      open-on-output "${monitorL}"
    }

    workspace "8" {
      open-on-output "${monitorC}"
    }

    workspace "5" {
      open-on-output "${monitorC}"
    }

    workspace "2" {
      open-on-output "${monitorC}"
    }

    workspace "9" {
      open-on-output "${monitorR}"
    }

    workspace "6" {
      open-on-output "${monitorR}"
    }

    workspace "3" {
      open-on-output "${monitorR}"
    }

    window-rule {
      match app-id=r#"blender"#
      open-on-output "${monitorC}"
      default-column-width { proportion 1.0; }
    }

    window-rule {
      match app-id=r#"blender"# title=r#"^Blender Render$"#
      open-floating true
    }

    window-rule {
      match app-id=r#"btop"#
      open-on-workspace "1"
    }

    window-rule {
      match app-id=r#"(discord)|(vesktop)"#
      default-column-width { proportion 0.77; }
      open-on-workspace "1"
    }

    window-rule {
      match app-id=r#"gamescope"#
      open-fullscreen true
      open-on-output "${monitorC}"
    }

    window-rule {
      match app-id=r#"firefox$"#
      open-on-workspace "3"
    }

    window-rule {
      match app-id=r#"firefox$"# title="^Picture-in-Picture$"
      open-floating true
    }

    window-rule {
      match app-id=r#"^org\.keepassxc\.KeePassXC$"#
      match app-id=r#"^org\.gnome\.World\.Secrets$"#

      block-out-from "screen-capture"
    }

    window-rule {
      match app-id=r#"^org\.libretro\.RetroArch$"#
      open-fullscreen true
    }

    window-rule {
      match app-id=r#"steam"#
      open-on-workspace "5"
      default-column-width { proportion 0.85; }
    }

    window-rule {
      match app-id=r#"steam"# title=r#"^Friends List$"#
      default-column-width { proportion 0.15; }
    }

    window-rule {
      match app-id=r#"org.telegram.desktop"#
      default-column-width { proportion 0.23; }
      open-on-workspace "1"
    }

    layer-rule {
      match namespace=r#"^rofi$"#
    }

    binds {
      Alt+F4 repeat=false { close-window; }
      Alt+Shift+F4 repeat=false { close-window; }
      Super+L { spawn "hyprlock"; }
      Mod+F { fullscreen-window; }
      Mod+Space { toggle-window-floating; }

      Mod+Return { spawn "kitty"; }
      Mod+D { spawn-sh "rofi -modi drun,run -show run -m ${monitorC}"; }
      Mod+Escape { spawn "rofi-power-menu.sh"; }
      Mod+E { spawn "nautilus"; }

      Print { screenshot-screen; }
      Shift+Print { screenshot; }
      Alt+Print { screenshot-window; }

      XF86AudioRaiseVolume allow-when-locked=true { spawn-sh "wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.1+ -l 1.0"; }
      XF86AudioLowerVolume allow-when-locked=true { spawn-sh "wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.1-"; }
      XF86AudioMute        allow-when-locked=true { spawn-sh "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"; }
      XF86AudioMicMute     allow-when-locked=true { spawn-sh "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"; }
      XF86AudioPlay        allow-when-locked=true { spawn-sh "media-control-with-cooldown.sh toggle"; }
      XF86AudioPause       allow-when-locked=true { spawn-sh "media-control-with-cooldown.sh toggle"; }
      XF86AudioPrev        allow-when-locked=true { spawn-sh "media-control-with-cooldown.sh cdprev"; }
      XF86AudioNext        allow-when-locked=true { spawn-sh "media-control-with-cooldown.sh next"; }
      XF86AudioStop        allow-when-locked=true { spawn-sh "mpc-toggle-random.sh"; }

      // Open/close the Overview: a zoomed-out view of workspaces and windows.
      // You can also move the mouse into the top-left hot corner,
      // or do a four-finger swipe up on a touchpad.
      //
      // This is a release bind.
      // Press and release Mod by itself to trigger it.
      /-Mod {
        release { toggle-overview; }
      }

      Mod+Left  { focus-column-left; }
      Mod+Down  { focus-window-down; }
      Mod+Up    { focus-window-up; }
      Mod+Right { focus-column-right; }
      Mod+H     { focus-column-left; }
      Mod+J     { focus-window-down; }
      Mod+K     { focus-window-up; }
      Mod+L     { focus-column-right; }

      Mod+Ctrl+Left  { move-column-left; }
      Mod+Ctrl+Down  { move-window-down; }
      Mod+Ctrl+Up    { move-window-up; }
      Mod+Ctrl+Right { move-column-right; }
      Mod+Ctrl+H     { move-column-left; }
      Mod+Ctrl+J     { move-window-down; }
      Mod+Ctrl+K     { move-window-up; }
      Mod+Ctrl+L     { move-column-right; }

      // Alternative commands that move across workspaces when reaching
      // the first or last window in a column.
      // Mod+J     { focus-window-or-workspace-down; }
      // Mod+K     { focus-window-or-workspace-up; }
      // Mod+Ctrl+J     { move-window-down-or-to-workspace-down; }
      // Mod+Ctrl+K     { move-window-up-or-to-workspace-up; }

      Mod+Home { focus-column-first; }
      Mod+End  { focus-column-last; }
      Mod+Ctrl+Home { move-column-to-first; }
      Mod+Ctrl+End  { move-column-to-last; }

      Mod+Shift+Left  { focus-monitor-left; }
      Mod+Shift+Down  { focus-monitor-down; }
      Mod+Shift+Up    { focus-monitor-up; }
      Mod+Shift+Right { focus-monitor-right; }
      Mod+Shift+H     { focus-monitor-left; }
      Mod+Shift+J     { focus-monitor-down; }
      Mod+Shift+K     { focus-monitor-up; }
      Mod+Shift+L     { focus-monitor-right; }

      Mod+Shift+Ctrl+Left  { move-column-to-monitor-left; }
      Mod+Shift+Ctrl+Down  { move-column-to-monitor-down; }
      Mod+Shift+Ctrl+Up    { move-column-to-monitor-up; }
      Mod+Shift+Ctrl+Right { move-column-to-monitor-right; }
      Mod+Shift+Ctrl+H     { move-column-to-monitor-left; }
      Mod+Shift+Ctrl+J     { move-column-to-monitor-down; }
      Mod+Shift+Ctrl+K     { move-column-to-monitor-up; }
      Mod+Shift+Ctrl+L     { move-column-to-monitor-right; }

      // Alternatively, there are commands to move just a single window:
      // Mod+Shift+Ctrl+Left  { move-window-to-monitor-left; }
      // ...

      // And you can also move a whole workspace to another monitor:
      // Mod+Shift+Ctrl+Left  { move-workspace-to-monitor-left; }
      // ...

      Mod+Page_Down      { focus-workspace-down; }
      Mod+Page_Up        { focus-workspace-up; }
      Mod+U              { focus-workspace-down; }
      Mod+I              { focus-workspace-up; }
      Mod+Ctrl+Page_Down { move-column-to-workspace-down; }
      Mod+Ctrl+Page_Up   { move-column-to-workspace-up; }
      Mod+Ctrl+U         { move-column-to-workspace-down; }
      Mod+Ctrl+I         { move-column-to-workspace-up; }

      // Alternatively, there are commands to move just a single window:
      // Mod+Ctrl+Page_Down { move-window-to-workspace-down; }
      // ...

      Mod+Shift+Page_Down { move-workspace-down; }
      Mod+Shift+Page_Up   { move-workspace-up; }
      Mod+Shift+U         { move-workspace-down; }
      Mod+Shift+I         { move-workspace-up; }

      // You can bind mouse wheel scroll ticks using the following syntax.
      // These binds will change direction based on the natural-scroll setting.
      //
      // To avoid scrolling through workspaces really fast, you can use
      // the cooldown-ms property. The bind will be rate-limited to this value.
      // You can set a cooldown on any bind, but it's most useful for the wheel.
      Mod+WheelScrollDown      cooldown-ms=150 { focus-workspace-down; }
      Mod+WheelScrollUp        cooldown-ms=150 { focus-workspace-up; }
      Mod+Ctrl+WheelScrollDown cooldown-ms=150 { move-column-to-workspace-down; }
      Mod+Ctrl+WheelScrollUp   cooldown-ms=150 { move-column-to-workspace-up; }

      Mod+WheelScrollRight      { focus-column-right; }
      Mod+WheelScrollLeft       { focus-column-left; }
      Mod+Ctrl+WheelScrollRight { move-column-right; }
      Mod+Ctrl+WheelScrollLeft  { move-column-left; }

      // Usually scrolling up and down with Shift in applications results in
      // horizontal scrolling; these binds replicate that.
      Mod+Shift+WheelScrollDown      { focus-column-right; }
      Mod+Shift+WheelScrollUp        { focus-column-left; }
      Mod+Ctrl+Shift+WheelScrollDown { move-column-right; }
      Mod+Ctrl+Shift+WheelScrollUp   { move-column-left; }

      // You can refer to workspaces by index. However, keep in mind that
      // niri is a dynamic workspace system, so these commands are kind of
      // "best effort". Trying to refer to a workspace index bigger than
      // the current workspace count will instead refer to the bottommost
      // (empty) workspace.
      //
      // For example, with 2 workspaces + 1 empty, indices 3, 4, 5 and so on
      // will all refer to the 3rd workspace.
      Mod+KP_End { focus-workspace "1"; }
      Mod+KP_Down { focus-workspace "2"; }
      Mod+KP_Next { focus-workspace "3"; }
      Mod+KP_Left { focus-workspace "4"; }
      Mod+KP_Begin { focus-workspace "5"; }
      Mod+KP_Right { focus-workspace "6"; }
      Mod+KP_Home { focus-workspace "7"; }
      Mod+KP_Up { focus-workspace "8"; }
      Mod+KP_Prior { focus-workspace "9"; }

      Mod+Shift+KP_End { move-window-to-workspace "1"; }
      Mod+Shift+KP_Down { move-window-to-workspace "2"; }
      Mod+Shift+KP_Next { move-window-to-workspace "3"; }
      Mod+Shift+KP_Left { move-window-to-workspace "4"; }
      Mod+Shift+KP_Begin { move-window-to-workspace "5"; }
      Mod+Shift+KP_Right { move-window-to-workspace "6"; }
      Mod+Shift+KP_Home { move-window-to-workspace "7"; }
      Mod+Shift+KP_Up { move-window-to-workspace "8"; }
      Mod+Shift+KP_Prior { move-window-to-workspace "9"; }

      // Switches focus between the current and the previous workspace.
      // Mod+Tab { focus-workspace-previous; }

      // The following binds move the focused window in and out of a column.
      // If the window is alone, they will consume it into the nearby column to the side.
      // If the window is already in a column, they will expel it out.
      Mod+BracketLeft  { consume-or-expel-window-left; }
      Mod+BracketRight { consume-or-expel-window-right; }

      // Consume one window from the right to the bottom of the focu0sed column.
      Mod+Comma  { consume-window-into-column; }
      // Expel the bottom window from the focused column to the right.
      Mod+Period { expel-window-from-column; }

      // Cycle through widths set in preset-column-widths.
      Mod+R { switch-preset-column-width; }
      // Cycling through the presets in reverse order is also possible.
      Mod+Shift+R { switch-preset-column-width-back; }

      Mod+Ctrl+Shift+R { switch-preset-window-height; }
      Mod+Ctrl+R { reset-window-height; }

      // Mod+F { maximize-column; }

      // While maximize-column leaves gaps and borders around the window,
      // maximize-window-to-edges doesn't: the window expands to the edges of the screen.
      // This bind corresponds to normal window maximizing,
      // e.g. by double-clicking on the titlebar.
      Mod+M { maximize-window-to-edges; }

      // Expand the focused column to space not taken up by other fully visible columns.
      // Makes the column "fill the rest of the space".
      Mod+Ctrl+F { expand-column-to-available-width; }

      Mod+C { center-column; }

      // Center all fully visible columns on screen.
      Mod+Ctrl+C { center-visible-columns; }

      // Finer width adjustments.
      // This command can also:
      // * set width in pixels: "1000"
      // * adjust width in pixels: "-5" or "+5"
      // * set width as a percentage of screen width: "25%"
      // * adjust width as a percentage of screen width: "-10%" or "+10%"
      // Pixel sizes use logical, or scaled, pixels. I.e. on an output with scale 2.0,
      // set-column-width "100" will make the column occupy 200 physical screen pixels.
      Mod+Minus { set-column-width "-10%"; }
      Mod+Equal { set-column-width "+10%"; }

      // Finer height adjustments when in column with other windows.
      Mod+Shift+Minus { set-window-height "-10%"; }
      Mod+Shift+Equal { set-window-height "+10%"; }

      // Move the focused window between the floating and the tiling layout.
      // Mod+Shift+V { switch-focus-between-floating-and-tiling; }

      // Toggle tabbed column display mode.
      // Windows in this column will appear as vertical tabs,
      // rather than stacked on top of each other.
      Mod+W { toggle-column-tabbed-display; }

      // Actions to switch layouts.
      // Note: if you uncomment these, make sure you do NOT have
      // a matching layout switch hotkey configured in xkb options above.
      // Having both at once on the same hotkey will break the switching,
      // since it will switch twice upon pressing the hotkey (once by xkb, once by niri).
      // Mod+Space       { switch-layout "next"; }
      // Mod+Shift+Space { switch-layout "prev"; }

      // Applications such as remote-desktop clients and software KVM switches may
      // request that niri stops processing the keyboard shortcuts defined here
      // so they may, for example, forward the key presses as-is to a remote machine.
      // It's a good idea to bind an escape hatch to toggle the inhibitor,
      // so a buggy application can't hold your session hostage.
      //
      // The allow-inhibiting=false property can be applied to other binds as well,
      // which ensures niri always processes them, even when an inhibitor is active.
      // Mod+Escape allow-inhibiting=false { toggle-keyboard-shortcuts-inhibit; }

      // The quit action will show a confirmation dialog to avoid accidental exits.
      Mod+Shift+E { quit; }
      Ctrl+Alt+Delete { quit; }
    }
    '';
in {
  home.packages = with pkgs; [
    # grim
    # slurp
    # wf-recorder
    # wl-clipboard
    # xhost
    # xprop
    # xrandr
    xwayland-satellite
  ];

  home.sessionVariables = {
    QT_QPA_PLATFORM = "wayland;xcb";
    GDK_BACKEND = "wayland,x11";
    NIXOS_OZONE_WL = "1";
  };

  xdg = {
    configFile."niri/config.kdl" = {
      force = true;
      source =
        pkgs.runCommand "niri-config-checked"
          {
            nativeBuildInputs = [ pkgs.niri ];
          }
          ''
            niri validate --config ${niriConfig}
            cp ${niriConfig} $out
          '';
    };
  };
}