{
  pkgs,
  ...
}: {
  imports = [
    ../common/applications/btop.nix
    ../common/applications/zsh.nix
  ];

  zsh.promptColor = "blue";

  home = {
    username = "rekyuu";
    homeDirectory = "/home/rekyuu";
  };

  home.packages = with pkgs; [
    comma
    direnv
    iotop
    jq
    lsof
    nix-direnv
    python3
    sl
    (buildEnv { name = "scripts"; paths = [ ../../scripts ]; })
  ];

  programs = {
    bash.enable = true;

    git = {
      enable = true;
      lfs.enable = true;
      settings = {
        user.name = "rekyuu";
        init.defaultBranch = "main";
        commit.gpgsign = true;
      };
    };

    home-manager.enable = true;
  };

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };

  home.sessionPath = [ ];

  home.sessionVariables = { };

  services = { };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "24.05";
}
