# Arch install procedure

- Set the console keyboard layout and font (`localectl list-keymaps`)
```bash
loadkeys hu
```
- Verify the boot mode
```bash
cat /sys/firmware/efi/fw_platform_size
```
- Setup system time
```bash
timedatectl set-timezone Europe/Budapest
```
- Partition the disks
```bash
fdisk -l
fdisk /dev/sda
# for boot partitions: n -> last sector: +1G
# for main partition: t -> partition id -> 8e (Linux LVM)
# to end: w
```
- Formatting partitions
```bash
mkfs.ext4 /dev/root_partition
mkswap /dev/swap_partition
mkfs.fat -F 32 /dev/efi_system_partition
```
- Encrypting partition & LVM setup
```bash
cryptsetup luksFormat /dev/sda3
cryptsetup open --type luks /dev/sda3 lvm
pvcreate /dev/mapper/lvm
vgcreate volgroup0 /dev/mapper/lvm
lvcreate -L 30GB volgroup0 -n lv_root
lvcreate -L 250GB volgroup0 -n lv_home
lvd
modprobe dm_mod
vgscan
vgchange -ay
mkfs.ext4 /dev/volgroup0/lv_root
mkfs.ext4 /dev/volgroup0/lv_home
```
- Mount the file systems
```bash
mount /dev/volgroup0/lv_root /mnt
mount --mkdir /dev/volgroup0/lv_home /mnt
mount --mkdir /dev/efi_system_partition /mnt/boot
swapon /dev/swap_partition
```
- Install essential packages
```bash
pacstrap -K /mnt base linux linux-firmware
```
- Generating fstab file & changing root & setting time zone
```bash
genfstab -U /mnt >> /mnt/etc/fstab
arch-chroot /mnt
ln -sf /usr/share/zoneinfo/Europe/Budapest /etc/localtime
hwclock --systohc
```
- Localization & hostname
```bash
echo LANG=en_US.UTF-8 > /etc/locale.conf
echo KEYMAP=hu > /etc/vconsole.conf
echo arch > /etc/hostname
```
- Initramfs
```bash
mkinitcpio -P
```
- Root password
```bash
passwd
```
### Optional: SSH access
```bash
systemctl start sshd
passwd
```