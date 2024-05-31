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
## Certificates
- the certificates namespace **must be** the same as the ingress

---
https://technotim.live/posts/kube-traefik-cert-manager-le/