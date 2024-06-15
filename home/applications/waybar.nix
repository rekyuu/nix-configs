{...} : {
  programs.waybar = {
    enable = true;

    settings.mainBar = {
      layer = "bottom";
      position = "top";
      height = 32;
      spacing = 0;
      output = ["DP-1"];
      modules-left = ["mpd"];
      modules-center = ["clock"];
      modules-right = [
        "cpu" 
        "custom/cpu-temp" 
        "custom/gpu-temp" 
        "tray"
      ];

      mpd = {
        format = "[{stateIcon}] [{repeatIcon}{randomIcon}{singleIcon}{consumeIcon}--] [{elapsedTime:%M:%S}/{totalTime:%M:%S}] {album} - {title}";
        format-disconnected = "mpd is offline";
        format-stopped = "[stopped] [{repeatIcon}{randomIcon}{singleIcon}{consumeIcon}--]";
        unknown-tag = "???";
        interval = 1;
        consume-icons = {
            off = "-";
            on = "c";
        };
        random-icons = {
            off = "-";
            on = "z";
        };
        repeat-icons = {
            off = "-";
            on = "r";
        };
        single-icons = {
            off = "-";
            on = "s";
        };
        state-icons = {
            paused = "paused";
            playing = "playing";
        };
      };

      clock = {
        interval = 1;
        format = "{:%A, %B %e, %Y - %H:%M:%S}";
        tooltip-format = "<span size='11pt' font='Cascadia Code'>{calendar}</span>";
        calendar = {
          mode ="month";
          mode-mon-col = 2;
          weeks-pos = "left";
          on-scroll = 1;
          on-click-right = "mode";
          format = {
            months = "<span color='#d6d6d6'><b>{}</b></span>";
            days = "<span color='#d6d6d6'>{}</span>";
            weeks = "<span color='#55b5db'><b>W{}</b></span>";
            weekdays = "<span color='#e6cd69'><b>{}</b></span>";
            today = "<span background='#d6d6d6' color='#151718'><b>{}</b></span>";
          };
        };
        actions = {
          on-click-right = "mode";
          on-scroll-up = "shift_up";
          on-scroll-down = "shift_down";
        };
      };

      cpu = {
        format = "[CPU {usage}%";
        tooltip = false;
      };

      # FIXME: these are bad/bork
      "custom/cpu-temp" = {
        exec = "echo \"$(sensors -j | jq \".[\\\"nct6799-isa-0290\\\"][\\\"CPUTIN\\\"][\\\"temp2_input\\\"]\" | xargs printf \"%.*f\" 1)°C\"";
        format = "{}] ";
        return-type = "";
        interval = 1;
      };

      "custom/gpu-temp" = {
        exec = "echo \"$(cat /sys/class/hwmon/hwmon0/device/gpu_busy_percent)% $(echo \"scale=1; $(cat /sys/class/hwmon/hwmon0/temp1_input) / 1000\" | bc)°C\"";
        format = "[GPU {}]";
        return-type = "";
        interval = 1;
      };

      tray = {
        spacing = 10;
      };
    };

    style = ''
      * {
        font-family: Cascadia Code;
        font-size: 15px;
        font-weight: bold;
      }

      window#waybar {
        background-color: #151718;
        color: #d6d6d6;
        transition-property: background-color;
        transition-duration: .5s;
      }

      #clock,
      #battery,
      #cpu,
      #memory,
      #disk,
      #temperature,
      #backlight,
      #network,
      #pulseaudio,
      #custom-media,
      #tray,
      #mode,
      #idle_inhibitor,
      #mpd {
        padding: 0 8px;
      }
    '';
  };
}