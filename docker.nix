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
    #daemon.settings = {
    #  default-runtime = "nvidia";
    #  runtimes.nvidia.path = "${pkgs.nvidia-docker}/bin/nvidia-container-runtime";
    #  exec-opts = ["native.cgroupdriver=cgroupfs"];
    #};
  };

  environment.systemPackages = with pkgs; [
    docker-compose
  ];
}
