{
  lib,
  pkgs,
  ...
}: {
  systemd.services.flamenco-worker = {
    description = "Flamenco Worker";
    documentation = [ "https://flamenco.blender.org" ];
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];

    serviceConfig = {
      Type = "simple";
      ExecStart = toString(pkgs.writeShellScript "flamenco-worker.sh" ''
        export PATH=$PATH:${lib.makeBinPath [ pkgs.blender pkgs.ffmpeg_7-full ]}
        ${(pkgs.callPackage ../../../pkgs/flamenco-worker {})}/bin/flamenco-worker -manager http://umiko.localdomain:8080
      '');
      Restart = "on-failure";
    };
  };
}