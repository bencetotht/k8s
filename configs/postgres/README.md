## Grant all permission for a user
```sql
GRANT ALL PRIVILEGES ON DATABASE erettsegi TO postgres;
GRANT ALL PRIVILEGES ON SCHEMA public TO postgres;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO postgres;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL PRIVILEGES ON TABLES TO postgres;
```
## Check for replication status:
```sql
SELECT client_addr, application_name, state, 
       pg_current_wal_lsn() - sent_lsn AS sent_lag,
       pg_current_wal_lsn() - write_lsn AS write_lag,
       pg_current_wal_lsn() - flush_lsn AS flush_lag,
       pg_current_wal_lsn() - replay_lsn AS replay_lag
FROM pg_stat_replication;
```