# Creating RBAC access and user with kubeconfig
## Generate certificate for the user
```sh
# Generate key
openssl genrsa -out read-only-user.key 2048
# Generate CSR
openssl req -new -key read-only-user.key -out read-only-user.csr -subj "/CN=read-only-user"
```
### Sign certificate for user
- Kubernetes CA key and certificate are at `/etc/kubernetes/pki/`
- for rancher: `/var/lib/rancher/k3s/server/tls/`
```sh
openssl x509 -req -in read-only-user.csr -CA /etc/kubernetes/pki/ca.crt -CAkey /etc/kubernetes/pki/ca.key -CAcreateserial -out read-only-user.crt -days 365
```
## Create a Kubernetes Role and Role Binding
- use files matching the desired role: `rbac-ro.yaml` or `rbac-rw.yaml`
## Create kubeconfig
- replace the values in `.kubeconfig`
```sh
# Base64 encode the CA certificate
cat /etc/kubernetes/pki/ca.crt | base64 | tr -d '\n'

# Base64 encode the user certificate
cat read-only-user.crt | base64 | tr -d '\n'

# Base64 encode the user key
cat read-only-user.key | base64 | tr -d '\n'
```