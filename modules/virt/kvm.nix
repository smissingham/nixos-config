{
  config,
  lib,
  pkgs,
  mainUser,
  ...
}:
let
  moduleSet = "myModules";
  moduleCategory = "virt";
  moduleName = "kvm";

  cfg = config.${moduleSet}.${moduleCategory}.${moduleName};
in
{
  options.${moduleSet}.${moduleCategory}.${moduleName} = with lib; {
    enable = mkEnableOption moduleName;
    restartGuestsOnBoot = mkOption {
      type = types.bool;
      default = true;
    };
    withCliTools = mkOption {
      type = types.bool;
      default = false;
    };
    withGuiTools = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = lib.mkIf cfg.enable {
    users.users.${mainUser.username}.extraGroups = [ "libvirtd" ];

    virtualisation = {
      spiceUSBRedirection.enable = true;
      libvirtd = {
        enable = true;
        allowedBridges = [
          "nm-bridge"
          "virbr0"
        ];
        onBoot = if cfg.restartGuestsOnBoot then "start" else "ignore";
        qemu = {
          package = pkgs.qemu_kvm;
          #runAsRoot = true;
          swtpm.enable = true;
          vhostUserPackages = [ pkgs.virtiofsd ];
          ovmf = {
            enable = true;
            packages = [
              (pkgs.OVMF.override {
                secureBoot = true;
                tpmSupport = true;
              }).fd
            ];
          };
        };
      };
    };

    environment.systemPackages =
      with pkgs;
      lib.mkMerge [

        # Always install packages
        ([
          virtiofsd
          virtio-win
        ])

        # # Optional CLI Tools -- NOT YET NEEDED, LIBVIRT package ships the cli tools
        (lib.mkIf cfg.withCliTools [
          libguestfs
        ])

        # Optional GUI Tools
        (lib.mkIf cfg.withGuiTools [
          virt-manager
        ])
      ];

    # Configure default network for libvirt
    systemd.services.libvirtd-default-network = {
      enable = true;
      description = "Creates and starts libvirt default network";
      wantedBy = [ "multi-user.target" ];
      after = [ "libvirtd.service" ];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = "yes";
      };
      script = ''
        # Wait for libvirtd to be ready
        sleep 2

        # Check if default network exists
        ${pkgs.libvirt}/bin/virsh net-info default >/dev/null 2>&1
        if [ $? -ne 0 ]; then
          # Create default network if it doesn't exist
          ${pkgs.libvirt}/bin/virsh net-define ${pkgs.writeText "default-network.xml" ''
            <network>
              <name>default</name>
              <forward mode='nat'/>
              <bridge name='virbr0' stp='on' delay='0'/>
              <ip address='172.16.1.1' netmask='255.255.255.0'>
                <dhcp>
                  <range start='172.16.100' end='172.16.1.254'/>
                </dhcp>
              </ip>
            </network>
          ''}
        fi

        # Start the network if it's not active
        ${pkgs.libvirt}/bin/virsh net-list | grep -q default || \
          ${pkgs.libvirt}/bin/virsh net-start default

        # Enable autostart
        ${pkgs.libvirt}/bin/virsh net-autostart default
      '';
    };
  };
}
