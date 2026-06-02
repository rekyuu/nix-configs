{
  lib,
  pkgs,
  ...
}: {
  systemd.services.flamenco-manager = {
    description = "Flamenco Manager";
    documentation = [ "https://flamenco.blender.org" ];
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];

    serviceConfig = {
      Type = "simple";
      WorkingDirectory = "-/etc/flamenco";
      ExecStart = toString(pkgs.writeShellScript "flamenco-manager.sh" ''
        export PATH=$PATH:${lib.makeBinPath [ pkgs.blender pkgs.ffmpeg_7-full ]}

        mkdir -p /etc/flamenco
        cd /etc/flamenco

        ${(pkgs.callPackage ../../../pkgs/flamenco-manager {})}/bin/flamenco-manager
      '');
      Restart = "on-failure";
    };
  };
}