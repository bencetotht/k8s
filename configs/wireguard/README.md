## Wireguard setup
Example config:
```conf
[Interface]
Address=172.16.0.1/24
ListenPort=60000
PrivateKey=<>
PostUp = iptables -A FORWARD -i wg0 -j ACCEPT; iptables -t nat -A POSTROUTING -o <public-interface> -j MASQUERADE;
PostDown = iptables -D FORWARD -i wg0 -j ACCEPT; iptables -t nat -D POSTROUTING -o <public-interface> -j MASQUERADE;

[Peer]
PublicKey=<>
AllowedIPs=0.0.0.0/0,10.10.10.0/24
Endpoint=192.168.88.51:60000 #other nodes ip
PersistentKeepalive = 25
```
- `Address` is the IP address of the vpn's interface
- `AllowedIPs` is the subnet of which the **PEER** HAS access to
- `Endpoint` is the IP of the WAN interface
- `PersistentKeepalive` is needed for NAT to be fully functional

### For site-to-site setups:
- important to have ip forwarding enabled: `sysctl net.ipv4.ip_forward=1`
- also run the following for iptables:
```bash
iptables -A FORWARD -i wg1 -j ACCEPT
iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
iptables -t nat -A POSTROUTING -o eth1 -j MASQUERADE
```

---
https://forum.proxmox.com/threads/proxmox-lxc-container-alpine-linux-set-up-wireguard-vpn-server-howto-05-2022-rev1.110778/
https://www.youtube.com/watch?v=BZvDSFwOjh4