#### CREATE PARTITIONS ON BLANK DISKS ####
for drive in /dev/nvme{0..3}n1; do
		
	# Create GPT partition tables
	parted -s "$drive" mklabel gpt
	
	# Create EFI partition
	parted -s "$drive" mkpart EFI fat32 1MiB 513MiB
	parted -s "$drive" set 1 boot on
	parted -s "$drive" mkpart primary 513MiB 100%
		
	mkfs.fat -F 32 "$drive"p1
done

#### CREATE LINUX MD RAID 10 ARRAY ####
mdadm --create --verbose /dev/md0 --level=10 --raid-devices=4 /dev/nvme{0..3}n1p2
echo "Waiting for raid array to initialize"
while [ "$(cat /proc/mdstat | grep -c "resync = ")" -eq 0 ]; do
	sleep 3
done
echo "Array initialized"

#### PRINT RESULTS TO SCREEN ####
lsblk
cat /proc/mdstat

#### CREATE ENCRYPTED LUKS VOLUME ####
cryptsetup --verbose --verify-passphrase luksFormat /dev/md0
cryptsetup luksOpen /dev/md0 luksraid

#### CREATE FILESYSTEMS AND MOUNTS ####
mkfs.ext4 /dev/mapper/luksraid
mkdir -p /mnt
mount /dev/mapper/luksraid /mnt

#### MOUNT BOOT PARTITIONS, FIRST AS PRIMARY
mount /dev/nvme0n1p1 /mnt/boot

mkdir -p /mnt/boot/efi{2,3,4}
mount /dev/nvme1n1p1 /mnt/boot/efi2
mount /dev/nvme2n1p1 /mnt/boot/efi3
mount /dev/nvme3n1p1 /mnt/boot/efi4

# print mounts to /mnt
df -h | grep /mnt
