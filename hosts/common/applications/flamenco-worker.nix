{
  lib,
  pkgs,
  ...
}: {
  systemd.user.services.flamenco-worker = {
    Unit = {
      Description = "Flamenco Worker";
      Documentation = "https://flamenco.blender.org";
      After = [ "network.target" ];
    };

    Service = {
      Type = "simple";
      Environment="";
      ExecStart = toString(
        pkgs.writeShellScript "flamenco-worker.sh" ''
          export PATH=$PATH:${lib.makeBinPath [ pkgs.blender-hip pkgs.ffmpeg_7-full ]}
          ${(pkgs.callPackage ../../../pkgs/flamenco-worker {})}/bin/flamenco-worker -manager http://umiko.localdomain:8080
        ''
      );
      Restart = "on-failure";
    };
  };
}