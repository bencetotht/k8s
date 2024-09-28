# changedetector.io - grafana visualizer
A small Python script that exports information about all active price watches on a changedetector.io site into a database, which can be used for visualizations in Grafana. 
## Setup
A postgres database is necessary to store the price history. You can setup the database using the included dockerfile, and the table using this command:
```sql
CREATE TABLE chio (
	id serial PRIMARY KEY,
	name VARCHAR(255) NOT NULL,
	timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	value NUMERIC NOT NULL
)
```
A virtual environment is recommended, but you can install the required packages globally too. Fill in the required values, and use crontab to automate the run of the script.

## Grafana dashboard
You can create a simple time series dashboard using a query like this:
```sql
SELECT "timestamp" AS time, value, name FROM chio ORDER BY "timestamp" 
```
You can also use the dashboard from `chio-dash.json`.