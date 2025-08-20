# K8s Infrastructure Repository

A comprehensive infrastructure and DevOps repository containing Kubernetes manifests, Docker configurations, Terraform infrastructure as code, Ansible playbooks, and automation scripts that I have used and written in the past years.

## 🏗️ Repository Structure

### Docker (`/docker/` and `/Dockerfiles`)
Docker-Compose files for running containerized applications.
- **Services**: SonarQube, Pi-hole, RabbitMQ, Grafana, Nextcloud, PostgreSQL
- **Development**: Code-server, Jupyter, development environments
- **Monitoring**: Gatus, Metricbeat, various exporters
- **Networking**: Traefik, HAProxy, WireGuard, Tailscale
- **Dockerfiles**: boilerplate for building custom images, like NextJS or Python Flask Application.

### Helm Charts (`/helm/`)
- **Databases**: MongoDB, PostgreSQL, Redis, InfluxDB
- **Monitoring**: Prometheus stack, Grafana
- **Applications**: WordPress, Rocket.Chat, Harbor, MinIO
- **Infrastructure**: Longhorn, Traefik, Cert-Manager

### Terraform (`/terraform/`)
Terraform IaC infrastructure.
- **Infrastructure**: Docker provider configurations
- **Networking**: Tailscale VPN setup
- **Provisioning**: Infrastructure as code templates
> [!NOTE]
> Most of my Terraform codes are found in [this production repository](https://github.com/bencetotht/bnbdevelopment-infra)

### Ansible (`/ansible/`)
Ansible Playbooks for provisioning HA applications automatically.
- **Cluster Setup**: RKE2, K3s preparation playbooks
- **High Availability**: HA PostgreSQL and MongoDB configurations
- **Keepalived**: Load balancer and failover setup
> [!WARNING]
> These playbooks are deprecated and not maintained. Find more playbooks in [my ansible repository](https://github.com/bencetotht/playbooks)

### Scripts (`/scripts/`)
Simple automation scripts to help reduce the amount of copy-pasting from websites.
- **Backup**: Database and system backup automation
- **Monitoring**: Temperature, metrics, and health checks
- **Setup**: Linux system configuration and Proxmox automations
- **Docker**: Container management and maintenance
> [!TIP]
> All of the scripts can be used with directly with `curl https://raw.githubusercontent.com/bencetotht/k8s/refs/heads/main/scripts/<SCRIPT_FOLDER>/<SCRIPT_NAME>.bash | bash`

> [!WARNING]
> You should never blindly invoke downloaded scripts from the internet. Please take a look at each of them to understand what they do before execute them.

### Workflows (`/workflows/`)
Bolierplates for production workflows.
- **GitHub Actions**: CI/CD pipeline configurations
- **Automation**: Deployment and testing workflows

### Kubernetes (`/kubernetes/`)
- **Applications**: Most common applications, although most is defined in Helm charts (e.g.: TeamCity, Ubuntu, Uptime Kuma, etc.)
- **Examples**: Sample deployments, services, and microservice demos
- **Monitoring**: Argo Rollouts, various application configurations

## 🤖 Automated Maintenance

This repository is automatically maintained to ensure security and keep dependencies up-to-date:

### Renovate Bot
- **Automated Updates**: Automatically creates pull requests for dependency updates
- **Security Patches**: Prioritizes security updates and vulnerability fixes
- **Version Management**: Handles both minor and patch updates with auto-merge capabilities
- **Configuration**: Uses recommended settings with custom rules for development dependencies

### Snyk Security
- **Vulnerability Scanning**: Continuously monitors for security vulnerabilities
- **Dependency Analysis**: Scans all dependencies for known security issues
- **Automated Alerts**: Provides real-time security notifications
- **Fix Recommendations**: Suggests secure versions and remediation steps

> [!TIP]
> Both tools work together to ensure your infrastructure remains secure and up-to-date with minimal manual intervention.

## 🤝 Contributing

This repository uses Renovate for automated dependency updates and follows infrastructure as code best practices. Contributions are welcome for:

- New Kubernetes manifests
- Additional Docker services
- Terraform modules
- Ansible playbooks
- Automation scripts

## 📄 License

This repository contains infrastructure configurations and automation scripts. Please ensure compliance with your organization's policies and licensing requirements.

---

*Built with ❤️ for modern infrastructure management*
