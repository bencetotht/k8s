# Prometheus queries (PromQL) for alerting

|Rule|Expression|
|:-:|:-:|
|Alert when host memory usage is high|`node_memory_MemAvailable_bytes / node_memory_MemTotal_bytes * 100 < 25`|


---
https://samber.github.io/awesome-prometheus-alerts/rules.html
