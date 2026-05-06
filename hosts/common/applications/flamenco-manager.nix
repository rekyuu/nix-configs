{
  lib,
  pkgs,
  ...
}: {
  systemd.user.services.flamenco-manager = {    
    Unit = {
      Description = "Flamenco Manager";
      Documentation = "https://flamenco.blender.org";
      After = [ "network.target" ];
    };

    Install = {
      WantedBy = [ "multi-user.target" ];
    };

    Service = {
      Type = "simple";
      WorkingDirectory = "/home/rekyuu/services/flamenco";
      ExecStart = toString(
        pkgs.writeShellScript "flamenco-manager.sh" ''
          export PATH=$PATH:${lib.makeBinPath [ pkgs.blender-hip pkgs.ffmpeg_7-full ]}
          ${(pkgs.callPackage ../../../pkgs/flamenco-manager {})}/bin/flamenco-manager
        ''
      );
      Restart = "on-failure";
    };
  };
}