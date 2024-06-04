# Authentik
To setup `values.yaml` correctly, replace the domain with the accurate.
Generate secure auth keys with openssl:
```bash
openssl rand 60 | base64
```

## Install
```bash
helm repo add authentik https://charts.goauthentik.io
helm repo update
helm install authentik authentik/authentik -f values.yaml
```

### Optional - Email alerts
Add to `values.yaml` this section:
```yaml
email:
    # -- SMTP Server emails are sent from, fully optional
    host: ""
    port: 587
    # -- SMTP credentials. When left empty, no authentication will be done.
    username: ""
    # -- SMTP credentials. When left empty, no authentication will be done.
    password: ""
    # -- Enable either use_tls or use_ssl. They can't be enabled at the same time.
    use_tls: false
    use_ssl: false
    timeout: 30
    # -- Email 'from' address can either be in the format "foo@bar.baz" or "authentik <foo@bar.baz>"
    from: ""
```

## Post-install
Default username is: `akadmin`