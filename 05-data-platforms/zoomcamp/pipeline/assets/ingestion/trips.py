"""@bruin

name: ingestion.trips
type: python
image: python:3.11
connection: duckdb-default

materialization:
  type: table
  strategy: append

columns:
  - name: VendorID
    type: integer
    description: TPEP/LPEP provider code
  - name: tpep_pickup_datetime
    type: timestamp
    description: Pickup date and time (yellow taxis)
  - name: tpep_dropoff_datetime
    type: timestamp
    description: Dropoff date and time (yellow taxis)
  - name: lpep_pickup_datetime
    type: timestamp
    description: Pickup date and time (green taxis)
  - name: lpep_dropoff_datetime
    type: timestamp
    description: Dropoff date and time (green taxis)
  - name: passenger_count
    type: float
    description: Number of passengers
  - name: trip_distance
    type: float
    description: Trip distance in miles
  - name: PULocationID
    type: integer
    description: Pickup location zone ID
  - name: DOLocationID
    type: integer
    description: Dropoff location zone ID
  - name: payment_type
    type: integer
    description: Payment type code
  - name: fare_amount
    type: float
    description: Fare amount in dollars
  - name: total_amount
    type: float
    description: Total amount charged
  - name: taxi_type
    type: string
    description: Type of taxi (yellow or green)
  - name: extracted_at
    type: timestamp
    description: Timestamp when the data was extracted

@bruin"""

import os
import json
import pandas as pd
from datetime import datetime
from dateutil.relativedelta import relativedelta


BASE_URL = "https://d37ci6vzurychx.cloudfront.net/trip-data/"


def materialize():
    start_date = os.environ.get("BRUIN_START_DATE", "2022-01-01")
    end_date = os.environ.get("BRUIN_END_DATE", "2022-02-01")
    bruin_vars = json.loads(os.environ.get("BRUIN_VARS", "{}"))
    taxi_types = bruin_vars.get("taxi_types", ["yellow"])

    start = datetime.strptime(start_date, "%Y-%m-%d")
    end = datetime.strptime(end_date, "%Y-%m-%d")

    all_frames = []
    current = start
    while current < end:
        year_month = current.strftime("%Y-%m")
        for taxi_type in taxi_types:
            filename = f"{taxi_type}_tripdata_{year_month}.parquet"
            url = f"{BASE_URL}{filename}"
            print(f"Fetching {url}")
            try:
                df = pd.read_parquet(url)
                df["taxi_type"] = taxi_type
                df["extracted_at"] = datetime.utcnow()
                all_frames.append(df)
                print(f"  -> {len(df)} rows")
            except Exception as e:
                print(f"  -> Failed: {e}")
        current += relativedelta(months=1)

    if not all_frames:
        return pd.DataFrame()

    result = pd.concat(all_frames, ignore_index=True)
    print(f"Total rows: {len(result)}")
    return result
