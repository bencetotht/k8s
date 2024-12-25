## Install Cert-Manager
- add helm repo
```bash
helm repo add jetstack https://charts.jetstack.io
```
- install cert-manager crds
```bash
kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.9.1/cert-manager.crds.yaml
```
- install the `jetstack/cert-manager` helm chart
## Setting up LetsEncrypt issuers:
```yaml
email: you@example.com
selector:
  dnsZones:
    - "example.com"
```
- replace the `email` with the email associated with cloudflare account
- replace the `dnsZones` with the domains
## Setting up Cloudflare API
```yaml
stringData:
  cloudflare-token: <FILL_IN>
```
- replace `cloudflare-token` with the actual token
- be sure you are generating an API token and not a global API key https://cert-manager.io/docs/configuration/acme/dns01/cloudflare/#api-tokens
- token should have the following permissions, according to [documentation](https://cert-manager.io/docs/configuration/acme/dns01/cloudflare/):
    - `Zone - DNS - Edit`
    - `Zone - Zone - Read`
## Certificates
- the certificates namespace **must be** the same as the ingress
- one way to resolve it is to use `emberstack/reflector` chart, and add the necessary annotations

---
https://technotim.live/posts/kube-traefik-cert-manager-le/