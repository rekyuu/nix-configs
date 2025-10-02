{
  pkgs,
  config,
  ...
}: {
  home.packages = with pkgs; [
    # https://github.com/NixOS/nixpkgs/issues/251551#issuecomment-2901198837
    (let
      inherit (config.home) username;
      inherit (lib) getExe;

      houdiniExe = getExe houdini;
      sesinetdExe = "${houdini}/houdini/sbin/sesinetd";
      licenseDir = "${config.xdg.dataHome}/houdini/licenses";
    in
      writeShellApplication {
        name = "houdini-run";
        runtimeInputs = [];
        text = ''
          mkdir -p ${licenseDir}
          ${sesinetdExe} ${licenseDir} --user ${username} --group ${username}
          ${houdiniExe}
        '';
      }
    )
  ];
}