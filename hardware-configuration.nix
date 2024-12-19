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
          path = "/boot1";
          devices = ["/dev/nvme0n1p1"];
        }
        {
          path = "/boot2";
          devices = ["/dev/nvme1n1p1"];
        }
        {
          path = "/boot3";
          devices = ["/dev/nvme2n1p1"];
        }
        {
          path = "/boot4";
          devices = ["/dev/nvme3n1p1"];
        }
      ];
    };
    efi = {
      canTouchEfiVariables = true;
    };
  };

  # Setup RAID
  boot.swraid = {
    enable = true;
    mdadmConf = ''
      MAILADDR nixosconfignotificat.flaccid440@passmail.net
      DEVICE /dev/nvme0n1p2 /dev/nvme1n1p2 /dev/nvme2n1p2 /dev/nvme3n1p2
      ARRAY /dev/md0 metadata=1.2 UUID=ARRAYUUID
    '';
  };

  # define encrypted root filesystem on linux md raid array
  fileSystems."/" = {
    device = "/dev/mapper/luksraid";
    fsType = "ext4";
  };

  # define redundant boot partitions
  fileSystems."/boot1" = {
    device = "/dev/nvme0n1p1";
    fsType = "vfat";
  };
  fileSystems."/boot2" = {
    device = "/dev/nvme1n1p1";
    fsType = "vfat";
  };
  fileSystems."/boot3" = {
    device = "/dev/nvme2n1p1";
    fsType = "vfat";
  };
  fileSystems."/boot4" = {
    device = "/dev/nvme3n1p1";
    fsType = "vfat";
  };

  # bind mount one to /boot where grub expects there must be a folder
  fileSystems."/boot" = {
    depends = [
      "/boot1"
    ];
    device = "/boot1";
    fsType = "vfat";
    options = [
      "bind"
    ];
  };

  # Ensure necessary kernel modules are available in initrd
  boot.initrd = {
    kernelModules = [
    ];
    availableKernelModules = [
      "dm-mod"
      "xhci_pci"
      "ahci"
      "usbhid"
      "usb_storage"
      "sd_mod"
      "nvme"
      "md"
      "raid10"
      "md-mod"
    ];
    luks.devices = {
      "luksraid" = {
        device = "/dev/disk/by-id/md-uuid-ARRAYUUID";
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
