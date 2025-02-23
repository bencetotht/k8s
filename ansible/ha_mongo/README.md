# Setting up MongoDB HA

## Initiate replicaset
```js
rs.initiate();
rs.add("ip_addr")
```

## Issue with AVX support:
*From MongoDB 4.2 the application requires the cpu to have AVX support.*
```sh
curl -fsSL https://pgp.mongodb.com/server-4.2.asc | gpg --dearmor -o /usr/share/keyrings/mongodb-server-4.2.gpg

echo "deb [signed-by=/usr/share/keyrings/mongodb-server-4.2.gpg] https://repo.mongodb.org/apt/debian buster/mongodb-org/4.2 main" | tee /etc/apt/sources.list.d/mongodb-org-4.2.list

apt update
apt install -y mongodb-org=4.2.23
```