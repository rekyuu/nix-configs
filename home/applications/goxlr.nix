{
  pkgs,
  ...
}: 
let
  goxlrConfig = pkgs.writeTextFile {
    name = "settings.json";
    text = builtins.readFile ../static/goxlr/settings.json;
  };
in {
  # this might not work out so great but I'll try it for now since I don't change settings that much
  # issues:
  # - profiles and settings can't save (obvious)
  # - profiles are binary files instead of text so not particularly great to track 
  # - sound board samples aren't tracked. could be tracked, but idk if I want to upload metal-pipe.mp3 to git
  # - sound board sample buttons are tracked via the profile
  # - I like goxlr-daemon being a systemd process but the tray doesn't work since it's sandboxed
  # possible solutions
  # - duplicate profiles and modify as needed, then replace the ones in the repo

  home.file = {
    ".local/share/goxlr-utility/profiles/Custom.goxlr".source = ../static/goxlr/profiles/Custom.goxlr;
    ".local/share/goxlr-utility/mic-profiles/Custom.goxlrMicProfile".source = ../static/goxlr/mic-profiles/Custom.goxlrMicProfile;
  };

  systemd.user.services.goxlr-daemon = {
    Unit = {
      Description = "Allows control of a TC-Helicon GoXLR or GoXLR Mini, by maintaining an interaction with it over USB in the background";
    };

    Install = {
      WantedBy = [ "graphical-session.target" ];
    };

    Service = {
      Type = "simple";
      ExecStart = "${pkgs.goxlr-utility}/bin/goxlr-daemon --config ${goxlrConfig}";
      ExecReload = "/bin/kill -HUP $MAINPID";
      Restart = "on-failure";
    };
  };
}