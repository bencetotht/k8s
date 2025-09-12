# Alertmanager & Prometheus
The `rules` folder contains various rules for many services and a general `alertmanager.yaml` configuration file.

## Rules
The rule files are named accordingly, and the main services these rules cover are:
- **Node Exporter**: alerts about general node health (CPU, RAM usage, etc.) and temperatures
- **Disk alerts**: smartctl and zfs alerts
- **UPS**: UPS alerts for the nut ups monitoring stack

### Credits / Links
- https://samber.github.io/awesome-prometheus-alerts/rules.html
