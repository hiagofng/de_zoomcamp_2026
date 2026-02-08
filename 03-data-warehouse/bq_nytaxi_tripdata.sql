CREATE OR REPLACE EXTERNAL TABLE ny_taxi.external_yellow_tripdata_2024
OPTIONS (
  format = 'parquet',
  uris = ['gs://de-zoomcamp_bucket02/yellow_tripdata_2024*']
)

CREATE OR REPLACE TABLE ny_taxi.yellow_tripdata_2024 AS
SELECT * FROM ny_taxi.external_yellow_tripdata_2024

select count(*) from ny_taxi.external_yellow_tripdata_2024

select 
  count(distinct(PULocationID)) as total_pulocations 
from ny_taxi.external_yellow_tripdata_2024

select 
  count(distinct(PULocationID)) as total_pulocations 
from ny_taxi.yellow_tripdata_2024

select 
  PULocationID
from `ny_taxi.yellow_tripdata_2024`

select 
  PULocationID,DOLocationID
from `ny_taxi.yellow_tripdata_2024`

select 
  count(1)
from `ny_taxi.yellow_tripdata_2024`
where fare_amount = 0


CREATE OR REPLACE TABLE ny_taxi.yellow_tripdata_2024_partitioned_clustered
PARTITION BY DATE(tpep_dropoff_datetime)
CLUSTER BY VendorID AS
SELECT * FROM ny_taxi.external_yellow_tripdata_2024

select 
  distinct(VendorID) 
from ny_taxi.yellow_tripdata_2024 
where tpep_dropoff_datetime between '2024-03-01' and '2024-03-15'

select 
  distinct(VendorID) 
from `ny_taxi.yellow_tripdata_2024_partitioned_clustered`
where tpep_dropoff_datetime between '2024-03-01' and '2024-03-15'

select count(*) from ny_taxi.yellow_tripdata_2024
