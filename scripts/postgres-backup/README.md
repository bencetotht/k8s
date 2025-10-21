# PostgreSQL Backup
### Permissions
```sql
-- Grant CONNECT to the database
GRANT CONNECT ON DATABASE db1 TO your_pg_user;

-- Grant USAGE on schema
GRANT USAGE ON SCHEMA public TO your_pg_user;

-- Grant SELECT on all tables in schema
GRANT SELECT ON ALL TABLES IN SCHEMA public TO your_pg_user;

-- Optional: future tables
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT SELECT ON TABLES TO your_pg_user;
```