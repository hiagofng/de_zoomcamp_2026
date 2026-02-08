# Module 3 Homework: Data Warehousing & BigQuery

## Data

For this homework we will be using the Yellow Taxi Trip Records for **January 2024 - June 2024** (not the entire year of data).

Parquet Files are available from the New York City Taxi Data found [here](https://www.nyc.gov/site/tlc/about/tlc-trip-record-data.page).

## Loading the data

You can use the following scripts to load the data into your GCS bucket:

- Python script: [load_yellow_taxi_data.py](./load_yellow_taxi_data.py)
- Jupyter notebook with DLT: [DLT_upload_to_GCP.ipynb](./DLT_upload_to_GCP.ipynb)

If you want to use the script, first download your credentials JSON file as `service-account.json` and then run:

```bash
uv run load_yellow_taxi_data.py
```

You will need to generate a Service Account with GCS Admin privileges or be authenticated with the Google SDK, and update the bucket name in the script.

If you are using orchestration tools such as Kestra, Mage, Airflow, or Prefect, do not load the data into BigQuery using the orchestrator.

Make sure that all 6 files show in your GCS bucket before beginning.

> [!NOTE]
> You will need to use the PARQUET option when creating an external table.

## BigQuery Setup

> Create an external table using the Yellow Taxi Trip Records.

```sql
CREATE OR REPLACE EXTERNAL TABLE ny_taxi.external_yellow_tripdata_2024
OPTIONS (
  format = 'parquet',
  uris = ['gs://de-zoomcamp_bucket02/yellow_tripdata_2024*']
);
```

> Create a regular, materialized table in BigQuery using the Yellow Taxi Trip Records. Do not partition or cluster this table.

```sql
CREATE OR REPLACE TABLE ny_taxi.yellow_tripdata_2024 
AS
SELECT * FROM ny_taxi.external_yellow_tripdata_2024
```

## Question 1. Counting records

> What is count of records for the 2024 Yellow Taxi Data?

```sql
select count(*) from ny_taxi.external_yellow_tripdata_2024
```

- **20,332,093**

## Question 2. Data read estimation

> Write a query to count the distinct number of PULocationIDs for the entire dataset on both the tables.

```sql
/* External table */
select 
  count(distinct(PULocationID)) as total_pulocations 
from ny_taxi.external_yellow_tripdata_2024

/* Materialized table */
select 
  count(distinct(PULocationID)) as total_pulocations 
from ny_taxi.yellow_tripdata_2024
```

> What is the **estimated amount** of data that will be read when this query is executed on the External Table and the Table?

- **0 MB for the External Table and 155.12 MB for the Materialized Table**

## Question 3. Understanding columnar storage

> Write a query to retrieve the PULocationID from the table (not the external table) in BigQuery. Now write a query to retrieve the PULocationID and DOLocationID on the same table.

```sql
/* 155.12 MB */
select 
  PULocationID
from `ny_taxi.yellow_tripdata_2024`

/* 310.24 MB */
select 
  PULocationID,DOLocationID
from `ny_taxi.yellow_tripdata_2024`
```

> Why are the estimated number of Bytes different?

- **BigQuery is a columnar database, and it only scans the specific columns requested in the query. Querying two columns (PULocationID, DOLocationID) requires reading more data than querying one column (PULocationID), leading to a higher estimated number of bytes processed.**

## Question 4. Counting zero fare trips

> How many records have a fare_amount of 0?

```sql
select 
  count(1)
from `ny_taxi.yellow_tripdata_2024`
where fare_amount = 0
```

- **8,333**

## Question 5. Partitioning and clustering

> What is the best strategy to make an optimized table in Big Query if your query will always filter based on tpep_dropoff_datetime and order the results by VendorID?

- **Partition by tpep_dropoff_datetime and Cluster on VendorID**

> Create a new table with this strategy.

```sql
CREATE OR REPLACE TABLE ny_taxi.yellow_tripdata_2024_partitioned_clustered
PARTITION BY DATE(tpep_dropoff_datetime)
CLUSTER BY VendorID AS
SELECT * FROM ny_taxi.external_yellow_tripdata_2024
```

## Question 6. Partition benefits

> Write a query to retrieve the distinct VendorIDs between tpep_dropoff_datetime 2024-03-01 and 2024-03-15 (inclusive).

```sql
/* Materialized table */
select 
  distinct(VendorID) 
from ny_taxi.yellow_tripdata_2024 
where tpep_dropoff_datetime between '2024-03-01' and '2024-03-15'

/* Partitioned and clustered table */
select 
  distinct(VendorID) 
from `ny_taxi.yellow_tripdata_2024_partitioned_clustered`
where tpep_dropoff_datetime between '2024-03-01' and '2024-03-15'
```

> Use the materialized table you created earlier in your from clause and note the estimated bytes.

- **310.24 MB**

> Now change the table in the from clause to the partitioned table you created for question 5 and note the estimated bytes processed.

- **26.84 MB**

> What are these values? Choose the answer which most closely matches.

- **310.24 MB for non-partitioned table and 26.84 MB for the partitioned table**

## Question 7. External table storage

> Where is the data stored in the External Table you created?

- **GCP Bucket**

## Question 8. Clustering best practices

> It is best practice in Big Query to always cluster your data:

- **False**, we should cluster when table is large (several GBs or TBs) and queries frequently use filters or aggregations on specific high-cardinality.

## Question 9. Understanding table scans

> No Points: Write a `SELECT count(*)` query FROM the materialized table you created.

```sql
select count(*) from ny_taxi.yellow_tripdata_2024
```

> How many bytes does it estimate will be read? Why?

0 bytes will be read because count(*) without a where clause can be answered directly from table metadata. Bigquery mantains row count information for each table.

## Submitting the solutions

Form for submitting: https://courses.datatalks.club/de-zoomcamp-2026/homework/hw3