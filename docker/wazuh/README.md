# Wazuh deployment with Docker
- Clone the repository
```bash
git clone https://github.com/wazuh/wazuh-docker.git -b v4.13.1
```
- Increase `max_map_count`
```bash
sysctl -w vm.max_map_count=262144
```
> You can also add it to the file `/etc/sysctl.conf` for permanent setting
- Generate self-signed certificates
```bash
docker compose -f generate-indexer-certs.yml run --rm generator
```
- To expose the service as an ingress with Traefik, add these labels to the `wazuh-dashboard` container:
```yaml
labels:
  - "traefik.enabled=true"
  - "traefik.http.routers.wazuh.entrypoints=web,websecure"
  - "traefik.http.routers.wazuh.rule=Host(`wazuh.local.bnbdevelopment.hu`)"
  - "traefik.http.routers.wazuh.service=wazuh"
  - "traefik.http.services.wazuh.loadbalancer.server.port=5601"
  - "traefik.http.services.wazuh.loadbalancer.server.scheme=https
```