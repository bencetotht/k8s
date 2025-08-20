#!/bin/bash

IMG_URL="https://cloud-images.ubuntu.com/releases/noble/release/ubuntu-24.04-server-cloudimg-amd64.img"
VMID=9000

# Cloud-init config
USERNAME="bence"
PASSWORD="bence"
SSHKEY=""


wget $IMG_URL

# create new vm with no disk
qm create $VMID --name "ubuntu-2404-cloudimg" --memory 4096 --cores 2 --net0 virtio,bridge=vmbr0 --agent enabled=1 --cpu host
qm set $VMID --serial0 socket --vga serial0

# format image
mv ubuntu-24.04-server-cloudimg-amd64.img ubuntu-24.04.qcow2
qemu-img resize ubuntu-24.04.qcow2 32G

# import image
qm importdisk $VMID ubuntu-24.04.qcow2 local-lvm
qm set $VMID --scsi0 local-lvm:vm-$VMID-disk-0,size=32G
# set boot order
qm set $VMID --boot 'order=ide0;ide2;net0'

# add cloud-init disk
qm set $VMID --ide2 local-lvm:cloudinit

# set cloud-init config
qm set $VMID --ciuser bence --cipassword $PASSWORD --nameserver 1.1.1.1 --searchdomain 1.1.1.1 --ssh-key $SSHKEY --ipconfig0 ip=dhcp

# regenerate cloud-init config
qm set $VMID -ide2 local-lvm:cloudinit
qm set $VMID -ide2 none,media=cdrom

# create template from VM
qm template $VMID
