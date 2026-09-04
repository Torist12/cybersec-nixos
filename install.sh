#!/usr/bin/env bash
set -e

echo "================================"
echo "  cybersec-nixos installer"
echo "================================"
echo ""

# --- 1. Show available disks ---
echo "Available disks:"
lsblk -d -o NAME,SIZE,MODEL
echo ""

read -p "Target disk (e.g. /dev/vda, /dev/nvme0n1): " DISK

if [ ! -b "$DISK" ]; then
  echo "Error: $DISK is not a valid block device."
  exit 1
fi

echo ""
echo "WARNING: This will ERASE ALL DATA on $DISK"
read -p "Type 'yes' to continue: " CONFIRM

if [ "$CONFIRM" != "yes" ]; then
  echo "Aborted."
  exit 1
fi

# --- 2. Set disk in disko config ---
echo ""
echo "==> Setting target disk in disko-config.nix"
sed -i "s|DISK_PLACEHOLDER|$DISK|g" disko-config.nix

# --- 3. Partition and format ---
echo ""
echo "==> Partitioning and formatting $DISK"
sudo nix --extra-experimental-features "nix-command flakes" run github:nix-community/disko -- --mode disko ./disko-config.nix

# --- 4. Generate hardware config ---
echo ""
echo "==> Generating hardware-configuration.nix"
sudo nixos-generate-config --root /mnt --show-hardware-config > hardware-configuration.nix

# --- 5. Install ---
echo ""
echo "==> Installing system (this will take a while)"
sudo nixos-install --flake .#cybersec-vm

echo ""
echo "================================"
echo "  Installation complete!"
echo "  Remove the installation media and reboot:"
echo "  sudo reboot"
echo "================================"