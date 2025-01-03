# Github Actions Runner Control (ARC) Install
## Installing the Actions Runner Controller
```bash
helm install arc -n arc-system --create-namespace oci://ghcr.io/actions/actions-runner-controller-charts/gha-runner-scale-set-controller
```
## Configuring a runner scale set
### Creating PAT
The following repository permissions are necessary:
- Actions (read only)
- Administration (read and write)
- Content (read only)
- Metadata (read only)
- Pull requests (read only)

### Installing chart
```bash
helm install arc-runner-set -n arc-runner --create-namespace oci://ghcr.io/actions/actions-runner-controller-charts/gha-runner-scale-set -f runner.yaml
```