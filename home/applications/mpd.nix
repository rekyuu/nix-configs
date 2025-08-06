{...}: {
  services.mpd = {
    enable = true;

    musicDirectory = "/mnt/rikka/music/library";
    playlistDirectory = "/mnt/rikka/music/playlists";

    network.listenAddress = "any";

    extraConfig = ''
      restore_paused "yes"
      auto_update "yes"
      replaygain "track"
      save_absolute_paths_in_playlists "yes"

      audio_output {
        type "pipewire"
        name "PipeWire Audio"
      }
    '';
  };

  services.mpd-discord-rpc = {
    enable = true;
    settings = {
      id = 880327448900821033;
      hosts = ["localhost:6600"];
      format = {
        details = "$title";
        state = "$album";
        timestamp = "elapsed";
        large_image = "";
        small_image = "";
        large_text = "";
        small_text = "";
      };
    };
  };
}