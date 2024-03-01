# Installing consul

Fill in the datacenter name
```bash
helm install <CLUSTER_NAME> hashicorp/consul -n consul-system --create-namespace --values values.yaml --set global.datacenter=<CLUSTER_NAME> --version 1.0.0
```

# Inject consul into services with annotations
```yaml
annotations:
    consul.hashicorp.com/connect-inject: 'true'
    consul.hashicorp.com/connect-service-upstreams: 'service:3000'
```
---
[CHART REFERNCE](https://developer.hashicorp.com/consul/docs/k8s/helm) | [PROMETHEUS VALUES](https://developer.hashicorp.com/consul/docs/agent/telemetry)