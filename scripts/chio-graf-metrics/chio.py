import os
from os.path import isfile
import psycopg2
from psycopg2 import sql
from datetime import datetime
import requests
import json

API_TOKEN= "" # API token from changedetector.io
BASE_DIR = "" # the folder where the 'datastore' directory is stored
BASE_URL = "http://cd.example.com/" # the URL of the changedetector site
DB_HOST="127.0.0.1" # IP of postgres
DB_USER= "admin" # username for login
DB_PASS= "admin" # password for login

def insert_doc(name, value):
    try:
        database = psycopg2.connect(
            database="chio",
            host=DB_HOST,
            port="5432",
            user=DB_USER,
            password=DB_PASS
        )

        cursor = database.cursor()

        query = sql.SQL("""
        INSERT INTO chio (name, value) VALUES (%s, %s)
        """)

        cursor.execute(query, [name, value])
        database.commit()

        cursor.close()
        database.close()

        print(f"Inserted metric: name={name}, value={value} at {datetime.now()}")
    except Exception as e:
        print(f"Error inserting document: {e}")

def get_values(name):
    try:
        database = psycopg2.connect(
            database="chio",
            host=DB_HOST,
            port="5432",
            user=DB_USER,
            password=DB_PASS
        )

        cursor = database.cursor()

        query = sql.SQL("""
        SELECT chio."filename" FROM chio WHERE chio.name = %s ORDER BY chio."timestamp" DESC;
        """)

        cursor.execute(query, [name])
        values = cursor.fetchall()

        cursor.close()
        database.close()
        return values
    except Exception as e:
        print(f'Error reading documents: {e}')

def query_chio(name, uuid):
    r = requests.get(f"{BASE_URL}api/v1/watch/{uuid}/history", headers={'x-api-key': API_TOKEN}, verify=False)
    if r.status_code != 200: print(f"response: {r.text}")
    else:
        filename = r.json()[sorted(r.json())[-1]]
        if not filename.split('/')[-1].endswith('.txt'): return
        content = open(f'{BASE_DIR}{filename}').read()
        content = json.loads(content)
        insert_doc(name=name, value=content["price"])
    
def get_watches():
    r = requests.get(f"{BASE_URL}api/v1/watch", headers={'x-api-key': API_TOKEN}, verify=False)
    return [[i, r.json()[i]['title']] for i in r.json().keys()]

if __name__ == "__main__":
    watches = get_watches()
    for watch in watches:
        query_chio(name=watch[1], uuid=watch[0])