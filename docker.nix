{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}: {
  nixpkgs.overlays = [(final: prev: let
    my-config-toml = prev.pkgs.writeText "config.toml" ''
      disable-require = false
      #swarm-resource = "DOCKER_RESOURCE_GPU"

      [nvidia-container-cli]
      #root = "/run/nvidia/driver"
      #path = "/usr/bin/nvidia-container-cli"
      environment = []
      #debug = "/var/log/nvidia-container-runtime-hook.log"
      ldcache = "/tmp/ld.so.cache"
      load-kmods = true
      no-cgroups = true
      #user = "root:video"
      ldconfig = "@@glibcbin@/bin/ldconfig"
    '';
  in {
    nvidia-docker = prev.pkgs.mkNvidiaContainerPkg {
      name = "nvidia-docker";
      containerRuntimePath = "runc";
      configTemplate = my-config-toml;
      additionalPaths = [(prev.pkgs.callPackage <nixpkgs/pkgs/applications/virtualization/nvidia-docker> {})];
    };
  })];

  virtualisation.docker.rootless = {
    enable = true;
    setSocketVariable = true;
    daemon.settings = {
      default-runtime = "nvidia";
      runtimes.nvidia.path = "${pkgs.nvidia-docker}/bin/nvidia-container-runtime";
      exec-opts = ["native.cgroupdriver=cgroupfs"];
    };
  };
}
