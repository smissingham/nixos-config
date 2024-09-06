{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}: let
  home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/release-24.05.tar.gz";
in {
  imports = [
    (import "${home-manager}/nixos")
  ];

  home-manager.users.root = {
    home.stateVersion = "24.05";

    programs.git = {
      enable = true;
      userName = "Sean Missingham";
      userEmail = "sean@missingham.net";
    };
  };

  home-manager.users.smissingham = {
    home.stateVersion = "24.05";

    programs.git = {
      enable = true;
      userName = "Sean Missingham";
      userEmail = "sean@missingham.net";
    };
  };

  home-manager.users.smissingham.home.pointerCursor = {
    gtk.enable = true;
    x11.enable = true;
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Amber";
    size = 28;
  };
}
