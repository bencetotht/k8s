# Setting up MongoDB HA

## Initiate replicaset
```js
rs.initiate();
rs.add("ip_addr")
```

## Debugging mongodb_exporter
Get user details:
```js
use admin;
db.getUser("mongodb_exporter");
```
If the user doesn't exist or doesn't have the sufficient permissions, add with the following commands:
```js
use admin;

// create new user
db.createUser({ user: "mongodb_exporter", pwd: "securepassword", roles: [ { role: "clusterMonitor", db: "admin" }, { role: "read", db: "local" } ] });

// grant permissions
db.updateUser("mongodb_exporter", { roles: [ { role: "clusterMonitor", db: "admin" }, { role: "read", db: "local" } ] });
```
## Issue with AVX support:
*From MongoDB 4.2 the application requires the cpu to have AVX support.*
```sh
curl -fsSL https://pgp.mongodb.com/server-4.2.asc | gpg --dearmor -o /usr/share/keyrings/mongodb-server-4.2.gpg

echo "deb [signed-by=/usr/share/keyrings/mongodb-server-4.2.gpg] https://repo.mongodb.org/apt/debian buster/mongodb-org/4.2 main" | tee /etc/apt/sources.list.d/mongodb-org-4.2.list

apt update
apt install -y mongodb-org=4.2.23
```

