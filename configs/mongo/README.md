# Add root user to database
```js
use database;
db.createUser({user: 'root',pwd: 'root', roles: [{role: 'readWrite', db: 'material'}]});
```
## Other methods
```js
db.getUser("reportsUser")
db.getRole( "readWrite", { showPrivileges: true } )
db.grantRolesToUser(
  "reportsUser",
  [
    { role: "readWrite", db: "products" } ,
    { role: "readAnyDatabase", db:"admin" }
  ]
)
```