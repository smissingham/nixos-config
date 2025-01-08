umount -lf /dev/md{0..127} >/dev/null 2>&1
mdadm --stop /dev/md{0..127} >/dev/null 2>&1
mdadm --remove /dev/md{0..127} >/dev/null 2>&1

for drive in /dev/nvme{0..3}n1; do
	wipefs --all --force "$drive"
	blkdiscard "$drive" -f
done

# Identify drives
lsblk
