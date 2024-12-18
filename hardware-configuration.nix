{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot.loader = {
    grub = {
      enable = true;
      device = "nodev";
      efiSupport = true;
      mirroredBoots = [
        {
          path = "/boot/efi2";
          devices = ["/dev/nvme1n1"];
        }
        {
          path = "/boot/efi3";
          devices = ["/dev/nvme2n1"];
        }
        {
          path = "/boot/efi4";
          devices = ["/dev/nvme3n1"];
        }
      ];
    };
    efi.canTouchEfiVariables = true;
  };

  # define encrypted root filesystem on linux md raid array
  fileSystems."/" = {
    device = "/dev/mapper/luksraid";
    fsType = "ext4";
  };

  # define redundant boot partitions
  fileSystems."/boot" = {
    device = "/dev/nvme0n1p1";
    fsType = "vfat";
  };
  fileSystems."/boot/efi2" = {
    device = "/dev/nvme1n1p1";
    fsType = "vfat";
  };
  fileSystems."/boot/efi3" = {
    device = "/dev/nvme2n1p1";
    fsType = "vfat";
  };
  fileSystems."/boot/efi4" = {
    device = "/dev/nvme3n1p1";
    fsType = "vfat";
  };

  # Setup RAID
  boot.swraid = {
    enable = true;
    mdadmConf = ''
      MAILADDR sean@missingham.com
      DEVICE /dev/nvme{0..3}n1p2
      ARRAY /dev/md0 metadata=1.2 UUID=c7fcab9c:e359610f:bbd79bc7:ce41fbb2
    '';
  };

  # Ensure necessary kernel modules are available in initrd
  boot.initrd = {
    kernelModules = [
      "nvme"
      "raid10"
      "md-mod"
    ];
    availableKernelModules = [
      "dm-mod"
      "xhci_pci"
      "ahci"
      "usbhid"
      "usb_storage"
      "sd_mod"
    ];
    luks.devices = {
      "luksraid" = {
        device = "/dev/disk/by-id/md-uuid-c7fcab9c:e359610f:bbd79bc7:ce41fbb2";
        preLVM = false; # If LUKS is on top of LVM, set this to true
        allowDiscards = true; # Optional, enables TRIM if supported by your SSD
      };
    };
  };

  swapDevices = [];
  boot.kernelModules = ["kvm-intel"];
  boot.kernelParams = ["boot.shell_on_fail"];
  boot.extraModulePackages = [];
  networking.useDHCP = lib.mkDefault true;
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  # #### NVIDIA CONFIG ####
  hardware.graphics.enable = true; # Enable OpenGL
  services.xserver.videoDrivers = ["nvidia"]; # Nvidia graphics driver
  hardware.nvidia-container-toolkit.enable = true; # Nvidia CDI support for docker/podman
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false;
    powerManagement.finegrained = false;
    open = false;
    nvidiaSettings = true;
  };
}
