{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}: {
  virtualisation.docker.enable = true;

  hardware.nvidia-container-toolkit.enable = true;

  # currently broken after 24.11, see https://github.com/NVIDIA/nvidia-container-toolkit/issues/434
  #virtualisation.docker.rootless = {
  #  enable = true;
  #  setSocketVariable = true;
  #};

  environment.systemPackages = with pkgs; [
    docker-compose
  ];
}
