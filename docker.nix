{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}: {
  virtualisation.docker.enable = true;

  hardware.nvidia-container-toolkit.enable = true;

  virtualisation.docker.rootless = {
    enable = true;
    setSocketVariable = true;
  };

  environment.systemPackages = with pkgs; [
    docker-compose
  ];
}
