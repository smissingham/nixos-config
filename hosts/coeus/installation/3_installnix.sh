#### INSTALL NIXOS ####

# get the UUID of the earlier created mdadm array
ARRAY_UUID_NVME_R10=$(mdadm --detail --scan /dev/md0 | grep -o 'UUID=[^ ]*' | cut -d= -f2)

# Use sed to replace the placeholder with the real UUID in the hardware file
sed -i "s/\(ARRAY_UUID_NVME_R10\s*=\s*\).*/\1\"$ARRAY_UUID_NVME_R10\";/" ../hardware.nix

# Copy configurations and git repo to /etc/nixos
mkdir -p /mnt/etc/nixos
cp -ra ../../../* /mnt/etc/nixos/

# Install NixOS
nixos-install --root /mnt --no-root-passwd --flake /mnt/etc/nixos#coeus

# Set user/root password
nixos-enter --root /mnt -c 'passwd smissingham'
#nixos-enter --root /mnt -c 'passwd root'

# Reboot to the new system
echo "Installation completed. Please reboot your system to start NixOS."
#reboot
