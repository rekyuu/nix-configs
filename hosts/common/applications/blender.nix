{
  pkgs,
  ...
}: let
  blender = pkgs.blender-53.blender;

  blenderOverride = blender.override {
    # config.rocmSupport = true;
    # config.cudaSupport = false;
  };

  blenderOverrideWithPackages = blenderOverride.withPackages (ps: [
    ps.cattrs
    ps.flatbuffers
    ps.glfw
    ps.iglo
    (ps.callPackage ../../../pkgs/python-packages/libigl {})
    ps.networkx
    ps.pyqt6
    ps.xxhash
  ]);
in {
  home.packages = [
    blenderOverrideWithPackages
  ];

  xdg = {
    desktopEntries = {
      blender = {
        name = "blender";
        exec = "${blenderOverrideWithPackages}/bin/blender";
      };
    };
  };
}