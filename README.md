Install(Unraid VM, 20GB)  
  
Boot on https://releases.nixos.org/nixos/unstable-small/nixos-22.05pre379797.c11d9597c1b/nixos-minimal-22.05pre379797.c11d9597c1b-x86_64-linux.iso  
  
On VNC:  
sudo passwd, root/root, ip a  
  
On SSH:  
parted /dev/vda -- mklabel gpt  
parted /dev/vda -- mkpart primary 512MiB -8GiB  
parted /dev/vda -- mkpart primary linux-swap -5GiB 100%  
parted /dev/vda -- mkpart ESP fat32 1MiB 512MiB  
parted /dev/vda -- set 3 esp on  
mkfs.ext4 -L nixos /dev/vda1  
mkswap -L swap /dev/vda2  
mkfs.fat -F 32 -n boot /dev/vda3  
mount /dev/disk/by-label/nixos /mnt  
mkdir -p /mnt/boot  
mount /dev/disk/by-label/boot /mnt/boot  
swapon /dev/vda2  
nixos-generate-config --root /mnt  
rm /etc/nixos/configuration.nix  
curl https://raw.githubusercontent.com/vvzvlad/rdp_desktops_cfg.nix/main/bootstrap.nix > /mnt/etc/nixos/configuration.nix  
nixos-install  
reboot  
  
curl https://raw.githubusercontent.com/vvzvlad/rdp_desktops_cfg.nix/main/flake.nix > /etc/nixos/flake.nix  && curl https://raw.githubusercontent.com/vvzvlad/rdp_desktops_cfg.nix/main/configuration.nix > /etc/nixos/configuration.nix  && curl https://raw.githubusercontent.com/vvzvlad/rdp_desktops_cfg.nix/main/awesome-kiosk.nix > /etc/nixos/awesome-kiosk.nix  && nixos-rebuild switch  


killall -u rdp1 ; killall -u rdp2 ; killall -u rdp3 ; killall -u rdp4 ; killall -u rdp5 ; killall -u rdp6 ; killall -u rdp7 ; killall -u rdp8 ; killall -u rdp9 ; killall -u rdp10 ; killall -u rdp11  
