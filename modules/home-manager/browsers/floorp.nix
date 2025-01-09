{
  config,
  lib,
  pkgs,
  mainUser,
  ...
}:

let
  moduleSet = "myHomeModules";
  moduleCategory = "browsers";
  moduleName = "floorp";

  cfg = config.${moduleSet}.${moduleCategory}.${moduleName};
in
{
  options.${moduleSet}.${moduleCategory}.${moduleName} = with lib; {
    enable = mkEnableOption moduleName;
  };

  config = lib.mkIf cfg.enable {
    home-manager = {
      users.${mainUser.username} =
        { pkgs, ... }:
        {
          programs.floorp = {
            enable = true;
          };
        };
    };
  };
}
