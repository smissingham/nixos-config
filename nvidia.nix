{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}: let
  nvidia-offload = pkgs.writeShellScriptBin "nvidia-offload" ''
    export __NV_PRIME_RENDER_OFFLOAD=1
    export __NV_PRIME_RENDER_OFFLOAD_PROVIDER=NVIDIA-G0
    export __GLX_VENDOR_LIBRARY_NAME=nvidia
    export __VK_LAYER_NV_optimus=NVIDIA_only
    exec -a "$0" "$@"
  '';
in {
  # Enable OpenGL
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };

  # Load nvidia driver for Xorg and Wayland
  services.xserver.videoDrivers = ["nvidia"];

  nixpkgs.config.nvidia.acceptLicense = true;

  hardware.nvidia = {
    # Modesetting is required.
    modesetting.enable = true;

    # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
    # Enable this if you have graphical corruption issues or application crashes after waking
    # up from sleep. This fixes it by saving the entire VRAM memory to /tmp/ instead
    # of just the bare essentials.
    powerManagement.enable = false;

    # Fine-grained power management. Turns off GPU when not in use.
    # Experimental and only works on modern Nvidia GPUs (Turing or newer).
    powerManagement.finegrained = false;

    # Use the NVidia open source kernel module (not to be confused with the
    # independent third-party "nouveau" open source driver).
    # Support is limited to the Turing and later architectures. Full list of
    # supported GPUs is at:
    # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus
    # Only available from driver 515.43.04+
    # Currently alpha-quality/buggy, so false is currently the recommended setting.
    open = false;

    # Enable the Nvidia settings menu,
    # accessible via `nvidia-settings`.
    nvidiaSettings = true;

    prime = {
      # Make sure to use the correct Bus ID values for your system!
      offload = {
        enable = true;
        enableOffloadCmd = true;
      };

      intelBusId = "PCI:00:02:0";
      nvidiaBusId = "PCI:01:00:0";
    };

    # Optionally, you may need to select the appropriate driver version for your specific GPU.
    #package = config.boot.kernelPackages.nvidiaPackages.stable;
    #package = config.boot.kernelPackages.nvidiaPackages.beta; # accentuates flickering issue
    #package = config.boot.kernelPackages.nvidiaPackages.production;

    ## CUSTOM DRIVER VERSIONS IN TESTING ##

    #  doesn't build, vulkan issue
    #package = config.boot.kernelPackages.nvidiaPackages.mkDriver {
    #  version = "560.35.03";
    #  sha256_64bit = "sha256-8pMskvrdQ8WyNBvkU/xPc/CtcYXCa7ekP73oGuKfH+M=";
    #  settingsSha256 = "";
    #  persistencedSha256 = "";
    #};

    # Doesn't build, vulkan issue
    #package = config.boot.kernelPackages.nvidiaPackages.mkDriver {
    #  version = "560.31.02";
    #  sha256_64bit = "sha256-0cwgejoFsefl2M6jdWZC+CKc58CqOXDjSi4saVPNKY0=";
    #  settingsSha256 = "sha256-A3SzGAW4vR2uxT1Cv+Pn+Sbm9lLF5a/DGzlnPhxVvmE=";
    #  persistencedSha256 = "";
    #};

    #  doesn't build, vulkan issue
    #package = config.boot.kernelPackages.nvidiaPackages.mkDriver {
    #  version = "560.28.03";
    #  sha256_64bit = "sha256-martv18vngYBJw1IFUCAaYr+uc65KtlHAMdLMdtQJ+Y=";
    #  settingsSha256 = "sha256-b4nhUMCzZc3VANnNb0rmcEH6H7SK2D5eZIplgPV59c8=";
    #  persistencedSha256 = "";
    #};

    # 2024-09-07 Best So Far
    package = config.boot.kernelPackages.nvidiaPackages.mkDriver {
      version = "555.58.02";
      sha256_64bit = "sha256-xctt4TPRlOJ6r5S54h5W6PT6/3Zy2R4ASNFPu8TSHKM=";
      settingsSha256 = "sha256-ZpuVZybW6CFN/gz9rx+UJvQ715FZnAOYfHn5jt5Z2C8=";
      persistencedSha256 = "sha256-xctt4TPRlOJ6r5S54h5W6PT6/3Zy2R4ASNFPu8TSHKM=";
    };

    # Stable games, firefox crashing
    # package = config.boot.kernelPackages.nvidiaPackages.mkDriver {
    #   version = "555.58";
    #   sha256_64bit = "sha256-bXvcXkg2kQZuCNKRZM5QoTaTjF4l2TtrsKUvyicj5ew=";
    #   settingsSha256 = "sha256-vWnrXlBCb3K5uVkDFmJDVq51wrCoqgPF03lSjZOuU8M=";
    #   persistencedSha256 = "";
    # };

    # Currently testing, should be latest update of stable driver version 550
    # 2024-09-01 Best so far...
    # package = config.boot.kernelPackages.nvidiaPackages.mkDriver {
    #   version = "550.107.02";
    #   sha256_64bit = "sha256-+XwcpN8wYCjYjHrtYx+oBhtVxXxMI02FO1ddjM5sAWg=";
    #   settingsSha256 = "sha256-WFZhQZB6zL9d5MUChl2kCKQ1q9SgD0JlP4CMXEwp2jE=";
    #   persistencedSha256 = "";
    # };

    # # firefox working, factorio flickering and black-screening
    # package = config.boot.kernelPackages.nvidiaPackages.mkDriver {
    # version = "550.100";
    # sha256_64bit = "sha256-imtfsoe/EfUFZzR4S9pkwQZKCcKqefayJewPtW0jgC0=";
    # settingsSha256 = "sha256-cDxhzZCDLtXOas5OlodNYGIuscpKmIGyvhC/kAQaxLc=";
    # persistencedSha256 = "";
    # };

    # Trialling older driver version 535 for better stability
    #package = config.boot.kernelPackages.nvidiaPackages.mkDriver {
    #  version = "535.183.01";
    #  sha256_64bit = "sha256-9nB6+92pQH48vC5RKOYLy82/AvrimVjHL6+11AXouIM=";
    #  settingsSha256 = "sha256-WFZhQZB6zL9d5MUChl2kCKQ1q9SgD0JlP4CMXEwp2jE=";
    #  persistencedSha256 = "";
    #};
  };
}
