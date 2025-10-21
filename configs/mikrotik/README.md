# MikroTik Router Management
## Setting up loadbalanced WAN connection
```bash
/ip firewall mangle

add chain=prerouting in-interface=bridge-lan connection-mark=no-mark \
    per-connection-classifier=both-addresses:2/0 action=mark-connection new-connection-mark=wan1_conn

add chain=prerouting in-interface=bridge-lan connection-mark=no-mark \
    per-connection-classifier=both-addresses:2/1 action=mark-connection new-connection-mark=wan2_conn

add chain=prerouting connection-mark=wan1_conn action=mark-routing new-routing-mark=to_wan1
add chain=prerouting connection-mark=wan2_conn action=mark-routing new-routing-mark=to_wan2

/ip route
add gateway=192.168.0.1 routing-mark=to_wan1 check-gateway=ping
add gateway=192.168.0.1 routing-mark=to_wan2 check-gateway=ping
```