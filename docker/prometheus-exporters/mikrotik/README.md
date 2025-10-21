# Mikrotik RouterOS Monitoring with Prometheus
1. Setup an additional user for monitoring in routeros
```bash
/user group add name=mktxp_group policy=api,read
/user add name=mktxp_user group=mktxp_group password=mktxp_user_password
```
2. Configure settings in `mktxp/mktxp.conf`
3. Add job to `prometheus.yaml`
```yaml
  - job_name: 'mktxp'
    static_configs:
      - targets: ['mktxp_machine_IP:49090']
```
4. Use the [Mikrotik MKTXP Exporter](https://grafana.com/grafana/dashboards/13679-mikrotik-mktxp-exporter/) dashboard