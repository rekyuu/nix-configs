{
  pkgs,
  ...
}: {
  systemd.user.services.jellyfin-rpc = {
    Unit = {
      Description = "Jellyfin-RPC Service";
      Documentation = "https://github.com/Radiicall/jellyfin-rpc";
      After = [ "network.target" ];
    };

    Install = {
      WantedBy = [ "graphical-session.target" ];
    };

    Service = {
      Type = "simple";
      ExecStart = "${(pkgs.callPackage ../../../pkgs/jellyfin-rpc {})}/bin/jellyfin-rpc";
      Restart = "on-failure";
    };
  };
}