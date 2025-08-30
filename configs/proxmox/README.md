# LACP BOND setup
```conf
auto bond0
iface bond0 inet manual
        bond-slaves eno1 enp8s10
        bond-miimon 100
        bond-mode 802.3ad
        bond-xmit-hash-policy layer2+3

auto vmbr0
iface vmbr0 inet static
        address 192.168.88.250/24
        gateway 192.168.88.1
        bridge-ports bond0
        bridge-stp off
        bridge-fd 0
```
- all bond options must match with the switch configuration
- first configure the bond on the device, then on the switch

# Export / Import LXC
```bash
vzdump 214 --mode stop --compress zstd --storage local
rsync -avz /var/lib/vz/dump/vzdump-lxc-214-2025_03_29-20_01_30.* root@pve3:/var/lib/vz/dump/
pct restore <new-vmid> /var/lib/vz/dump/vzdump-lxc-258-2025_08_28-17_40_57.tar.zst --storage local-lvm
```
