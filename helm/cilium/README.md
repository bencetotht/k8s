# Cilium CNI
## Install
```bash
# install crds
helm install cilium cilium/cilium --version 1.18.1 --namespace kube-system --values crd-values.yaml --set installCRDs=true
# install daemonset
helm upgrade --install cilium cilium/cilium --version 1.18.1 --namespace kube-system -f crd-values.yaml
```
## Enable Hubble: Real‑Time Observability
```bash
cilium hubble enable
cilium hubble port-forward 
```

## Enable ClusterMesh
```bash
# enable on both clusters
cilium clustermesh enable --context homelab
cilium clustermesh enable --context cloud
# connect clusters
cilium clustermesh connect --context homelab --destination-context cloud
# verify status
cilium clustermesh status --context homelab
```

## Setting up with Talos Linux
Check the following guides:
- https://docs.cilium.io/en/stable/installation/k8s-install-helm/
- https://www.talos.dev/v1.10/kubernetes-guides/network/deploying-cilium/#machine-config-preparation