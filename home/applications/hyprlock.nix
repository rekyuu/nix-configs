{...}: 
let
  monitorL = "HDMI-A-1";
  monitorC = "DP-1";
  monitorR = "DP-2";
in {
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
}