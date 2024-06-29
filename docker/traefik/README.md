# Exposing a service with annotations:
```yaml
    labels:
      - "traefik.enable=true"
      - "traefik.http.routers.my-router.rule=Host(`my.custom.domain`)"
      - "traefik.http.services.my-service.loadbalancer.server.port=8080"
```

## Using different network:
Container network config:
```yaml
    networks:
      - traefik_backend
```
Compose network config:
```yaml
networks:
  traefik_backend:
    external: true
```