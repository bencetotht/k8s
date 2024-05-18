## Generating password:
```sh
apt install apache2-utils
htpasswd -nb <USERNAME> password | openssl base64
```

- Replace `USERNAME` with actual username

---
https://technotim.live/posts/kube-traefik-cert-manager-le/