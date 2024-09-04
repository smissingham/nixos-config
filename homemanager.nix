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
    /*
    The home.stateVersion option does not have a default and must be set
    */
    home.stateVersion = "24.05";
    /*
    Here goes the rest of your home-manager config, e.g. home.packages = [ pkgs.foo ];
    */

    programs.git = {
      enable = true;
      userName = "Sean Missingham";
      userEmail = "sean@missingham.net";
    };
  };
  home-manager.users.smissingham = {
    /*
    The home.stateVersion option does not have a default and must be set
    */
    home.stateVersion = "24.05";
    /*
    Here goes the rest of your home-manager config, e.g. home.packages = [ pkgs.foo ];
    */

    programs.git = {
      enable = true;
      userName = "Sean Missingham";
      userEmail = "sean@missingham.net";
    };
  };
}
