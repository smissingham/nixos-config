{
  config,
  lib,
  pkgs,
  mainUser,
  ...
}:
let
  moduleSet = "mySystemModules";
  moduleCategory = "virt";
  moduleName = "kvm";

  cfg = config.${moduleSet}.${moduleCategory}.${moduleName};
in
{
  options.${moduleSet}.${moduleCategory}.${moduleName} = with lib; {
    enable = mkEnableOption moduleName;
    withCliTools = mkOption {
      type = types.bool;
      default = false;
    };
    withGuiTools = mkOption {
      type = types.bool;
      default = false;
    };
    restartGuestsOnBoot = mkOption {
      type = types.bool;
      default = true;
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
          runAsRoot = true;
          swtpm.enable = true;
          vhostUserPackages = [ pkgs.virtiofsd ]; # causing freezing/lagging issues?
          ovmf = {
            enable = true;
            packages = [
              (pkgs.OVMF.override {
                secureBoot = true;
                tpmSupport = true;
              }).fd
            ];
          };
          verbatimConfig = ''
            <video>
              <model type='virtio' vram='16384' heads='1'/>
            </video>
            <graphics type='spice' port='-1' autoport='yes' listen='0.0.0.0'>
              <listen type='address' address='0.0.0.0'/>
            </graphics>
          '';
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
          #libguestfs
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
