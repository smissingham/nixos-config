{
  config,
  lib,
  pkgs,
  modulesPath,
  inputs,
  settings,
  localpkgs,
  ...
}: let
  #mypkgs = pkgs.linuxPackages.pkgs;
  # configFile = pkgs.writeText "akvcam-configFile" ''
  #   [Cameras]
  #   cameras/size = 2
  #   cameras/1/type = output
  #   cameras/1/mode = mmap, userptr, rw
  #   cameras/1/description = Virtual Camera (output device)
  #   cameras/1/formats = 2
  #   cameras/1/videonr = 7
  #   cameras/2/type = capture
  #   cameras/2/mode = mmap, rw
  #   cameras/2/description = Virtual Camera
  #   cameras/2/formats = 1, 2
  #   cameras/2/videonr = 9
  #   [Connections]
  #   connections/size = 1
  #   connections/1/connection = 1:2
  #   [Formats]
  #   formats/size = 2
  #   formats/1/format = YUY2
  #   formats/1/width = 640
  #   formats/1/height = 480
  #   formats/1/fps = 30
  #   formats/2/format = RGB24, YUY2
  #   formats/2/width = 640
  #   formats/2/height = 480
  #   formats/2/fps = 20/1, 15/2
  # '';
in {
  environment.systemPackages = with pkgs; [
    webcamoid
    linuxKernel.packages.linux_zen.akvcam
  ];

  boot.extraModulePackages = [config.boot.kernelPackages.akvcam];
  boot.kernelModules = ["akvcam"];
  # boot.extraModprobeConfig = ''
  #   options akvcam config_file=${configFile}
  # '';
}
