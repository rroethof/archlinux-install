#!/bin/sh

X_EFS_PATH="/boot"
export X_EFS_PATH
USERNAME="rroethof"

sgdisk --zap-all /dev/nvme0n1;

sgdisk --clear \
  --new=1:0:+1G --typecode=1:ef00 --change-name=1:EFI \
  --new=2:0:0 --typecode=2:8300 --change-name=2:cryptsystem \
  /dev/nvme0n1;


cryptsetup luksFormat --type luks2 --cipher aes-xts-plain64 /dev/disk/by-partlabel/cryptsystem
cryptsetup open /dev/disk/by-partlabel/cryptsystem system

mkfs.btrfs --label system /dev/mapper/system
mount -t btrfs LABEL=system /mnt
btrfs subvolume create /mnt/@root
btrfs subvolume create /mnt/@home
btrfs subvolume create /mnt/@var-lib
btrfs subvolume create /mnt/@libvirt
btrfs subvolume create /mnt/@docker
btrfs subvolume create /mnt/@var
btrfs subvolume create /mnt/@var-log
btrfs subvolume create /mnt/@var-log-audit
btrfs subvolume create /mnt/@snapshots
umount -R /mnt
mount -t btrfs -o defaults,x-mount.mkdir,compress=zstd,ssd,noatime,subvol=@root LABEL=system /mnt
mount -t btrfs -o defaults,x-mount.mkdir,compress=zstd,ssd,noatime,subvol=@home LABEL=system /mnt/home
mount -t btrfs -o defaults,x-mount.mkdir,compress=zstd,ssd,noatime,subvol=@snapshots LABEL=system /mnt/.snapshots
mount -t btrfs -o defaults,x-mount.mkdir,compress=zstd,ssd,noatime,subvol=@var LABEL=system /mnt/var
mount -t btrfs -o defaults,x-mount.mkdir,compress=zstd,ssd,noatime,subvol=@var-lib LABEL=system /mnt/var/lib
mount -t btrfs -o defaults,x-mount.mkdir,compress=zstd,ssd,noatime,subvol=@libvirt LABEL=system /mnt/var/lib/libvirt
mount -t btrfs -o defaults,x-mount.mkdir,compress=zstd,ssd,noatime,subvol=@docker LABEL=system /mnt/var/lib/docker
mount -t btrfs -o defaults,x-mount.mkdir,compress=zstd,ssd,noatime,subvol=@var-log LABEL=system /mnt/var/log
mount -t btrfs -o defaults,x-mount.mkdir,compress=zstd,ssd,noatime,subvol=@var-log-audit LABEL=system /mnt/var/log/audit

mkfs.fat -F32 -n EFI /dev/disk/by-partlabel/EFI
mkdir -p /mnt"$X_EFS_PATH"
mount LABEL=EFI /mnt"$X_EFS_PATH"

awk -i inplace '{ gsub(/#?ParallelDownloads\s*=.+$/, "ParallelDownloads=50"); }; { print }' /etc/pacman.conf

pacstrap /mnt \
  base \
  linux \
  linux-firmware \
  networkmanager \
  base-devel \
  btrfs-progs \
  gptfdisk \
  fish \
  sudo \
  ttf-dejavu \
  sbctl \
  intel-ucode \
  polkit \
  fish \
  pkgfile \
  git \
  efibootmgr \
  dialog \
  neovim \
  terminus-font \
  git
genfstab -L -p /mnt > /mnt/etc/fstab
