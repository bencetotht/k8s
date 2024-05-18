# Installing MetalLB on Kubernetes cluster
```bash
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.14.5/config/manifests/metallb-native.yaml
```

## Create configuration and IP-pool
```yaml
apiVersion: metallb.io/v1beta1
kind: IPAddressPool
metadata:
  name: k3s-lb-pool
  namespace: metallb-system
spec:
  addresses:
  - 10.10.10.201-10.10.10.210
---
apiVersion: metallb.io/v1beta1
kind: L2Advertisement
metadata:
  name: k3s-lb-pool
  namespace: metallb-system
```

---
https://medium.com/@eng.fernandosilva/3-node-k3s-cluster-with-etcd-and-metallb-4ddc7dcfb303
https://www.reddit.com/r/homelab/comments/mvjc0f/metallb_and_traefik_for_a_home_kubernetes_cluster/?rdt=51465
