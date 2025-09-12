#!/bin/bash

IMG_URL="https://factory.talos.dev/image/88d1f7a5c4f1d3aba7df787c448c1d3d008ed29cfb34af53fa0df4336a56040b/v1.10.4/nocloud-amd64.iso"
VMID=9001
STORAGE_POOL="local-lvm"
PASSWORD="bence"
SSHKEY=""

wget $IMG_URL

qm create $VMID --name "talos-template" --memory 16384 --cores 2 --sockets 2 --net0 virtio,bridge=vmbr0 --agent enabled=1 --cpu host

qm set $VMID --ide1 $STORAGE_POOL:32 # add main drive
qm set $VMID --ide2 $STORAGE_POOL:cloudinit # add cloud-init drive
qm importdisk $VMID nocloud-amd64.iso $STORAGE_POOL # load iso
qm set $VMID --ide0 $STORAGE_POOL:vm-$VMID-disk-1,media=cdrom # add optical drive with iso
qm set $VMID --boot 'order=ide1;ide0;net0'
# set cloud-init config
qm set $VMID --ciuser bence --cipassword $PASSWORD --nameserver 1.1.1.1 --searchdomain 1.1.1.1 --ssh-key $SSHKEY --ipconfig0 ip=dhcp
# regenerate cloud-init config
qm set $VMID -ide2 $STORAGE_POOL:cloudinit
qm set $VMID -ide2 none,media=cdrom
# create template from VM
qm template $VMID
