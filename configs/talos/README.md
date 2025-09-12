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
You can request a specific image from the image factory:
```bash
curl -X POST --data-binary @nocloud.yaml https://factory.talos.dev/schematics
```
This will return an id, which you can use to download the image from: `https://factory.talos.dev/image/<DISK_ID>/v1.10.4/nocloud-amd64.iso`
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
#### Configuring Longhorn
To configure Longhorn you need to enable the following extensions:
```yaml
customization:
  systemExtensions:
    officialExtensions:
      - siderolabs/iscsi-tools
      - siderolabs/util-linux-tools
```
When upgrading a Talos Linux node, always include the `--preserve` option in the command. This option explicitly tells Talos to keep ephemeral data intact.
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
This step usually takes multiple minutes. Check console output for activity:
```bash
talosctl --talosconfig talosconfig dashboard -e $ENDPOINT_IP -n $CONTROL_PLANE_IP
```

## Using the Cluster
```bash
# configure endpoints
talosctl config endpoint $CONTROL_PLANE_IP
talosctl config node $CONTROL_PLANE_IP
# retrieve kubeconfig
talosctl --talosconfig $TALOSCONFIG kubeconfig .
# use kubectl
kubectl get all --kubeconfig kubeconfig
```

## Advanced
### Configure Cilium CNI 
Check out the Cilium documentation under `/helm/cilium`

### Longhorn
To configure Longhorn, add the following section into your patch file:
```yaml
machine:
  kubelet:
    extraMounts:
      - destination: /var/lib/longhorn
        type: bind
        source: /var/lib/longhorn
        options:
          - bind
          - rshared
          - rw
# For V2 Volumes
  sysctls:
    vm.nr_hugepages: "1024"
  kernel:
    modules:
      - name: nvme_tcp
      - name: vfio_pci
```
Before installing Longhorn, create the namespace and label with privileged mode:
```bash
kubectl create ns longhorn-system
kubectl label namespace longhorn-system pod-security.kubernetes.io/enforce=privileged
```
During node upgrades, you must include the `--preserve` flag.
```bash
talosctl upgrade --nodes 10.20.30.40 --image ghcr.io/siderolabs/installer:v1.7.6 --preserve
```
If you do not include the `--preserve` option, Talos wipes /var/lib/longhorn, destroying all replicas stored on that node.