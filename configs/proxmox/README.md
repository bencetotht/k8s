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