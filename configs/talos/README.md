# Kubernetes Cluster using Talos OS
## Download ISO
> The images differ based on the selected platforms.
```bash
# proxmox bare metal install for amd64 arch
curl https://factory.talos.dev/image/376567988ad370138ad8b2698212367b8edcb69b5fd68c80be1f2ec7d603b4ba/v1.10.4/metal-amd64.iso -L -o metal-amd64.iso
# bare metal
curl https://github.com/siderolabs/talos/releases/download/v1.10.4/metal-amd64.iso -L -o metal-amd64.iso
```
View all releases [here](github.com/siderolabs/talos/releases) or [build your own image](https://factory.talos.dev/).

### Regarding Networking
If you don't have DHCP enabled, you can configure static IP by pressing `e` on the boot time.
```bash
ip=<client-ip>:<srv-ip>:<gw-ip>:<netmask>:<host>:<device>:<autoconf>
# like
ip=192.168.0.100::192.168.0.1:255.255.255.0::eth0:off
```
## Generate Machine Configurations
```bash
talosctl gen config talos-proxmox-cluster https://$CONTROL_PLANE_IP:6443 --output-dir conf --install-image factory.talos.dev/installer/ce4c980550dd2ab1b17bbf2b08801c7eb59418eafe8f279833297925d67c7515:v1.10.3
```
Alternatively, you can generate secrets separately:
```bash
talosctl gen secrets -o secrets.yaml
talosctl gen config --with-secrets secrets.yaml <cluster-name> <cluster-endpoint> #... args
```
You can also define a `patch.yaml` file to override configurations. 
```bash
talosctl gen config talos-proxmox-cluster https://$CONTROL_PLANE_IP:6443 --config-patch @patch.yaml #... args
```
### Advanced Configurations
#### Setting up HA using external loadbalancer:
##### Dedicated load balancer:
Create an appropriate frontend for the endpoint, listening on TCP port 6443, and point the backends at the addresses of each of the Talos control plane nodes. Your Kubernetes endpoint will be the IP address of the load balancer front end, with the port appended.
##### Layer 2 VIP Shared IP
```yaml
machine:
  network:
    interfaces:
      - interface: enp2s0
        dhcp: true
        vip:
          ip: 192.168.88.50
```

## Configuring Control Panes
```bash
talosctl apply-config --insecure --nodes $CONTROL_PLANE_IP --file conf/controlplane.yaml
```

## Configuring Worker nodes
```bash
talosctl apply-config --insecure --nodes $WORKER_IP --file _out/worker.yaml
```

## Bootstrapping the cluster
You first need to export the location of your `talosconfig` file into an environment variable.
```bash
export TALOSCONFIG="/home/bence/talos/conf/talosconfig"
```
Configure endpoints:
```bash
talosctl --talosconfig $TALOSCONFIG config endpoint <control plane 1 IP>
talosctl --talosconfig $TALOSCONFIG config node <control plane 1 IP>
```
Bootstrap cluster:
```bash
talosctl --talosconfig $TALOSCONFIG bootstrap
```

## Using the Cluster
```bash
# configure endpoints
talosctl config endpoint $CONTROL_PLANE_IP
talosctl config node $CONTROL_PLANE_IP
# retrieve kubeconfig
talosctl --talosconfig $TALOSCONFIG kubeconfig .
```

## Advanced
### Configure Cilium CNI 
```bash
helm install \
    cilium \
    cilium/cilium \
    --version 1.15.6 \
    --namespace kube-system \
    --set ipam.mode=kubernetes \
    --set kubeProxyReplacement=false \
    --set securityContext.capabilities.ciliumAgent="{CHOWN,KILL,NET_ADMIN,NET_RAW,IPC_LOCK,SYS_ADMIN,SYS_RESOURCE,DAC_OVERRIDE,FOWNER,SETGID,SETUID}" \
    --set securityContext.capabilities.cleanCiliumState="{NET_ADMIN,SYS_ADMIN,SYS_RESOURCE}" \
    --set cgroup.autoMount.enabled=false \
    --set cgroup.hostRoot=/sys/fs/cgroup
```