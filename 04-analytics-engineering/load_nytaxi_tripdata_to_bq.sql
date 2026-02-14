CREATE OR REPLACE EXTERNAL TABLE nytaxi.external_yellow_tripdata
OPTIONS (
  format = 'parquet',
  uris = ['gs://de-zoomcamp_bucket02/yellow_tripdata*']
)

CREATE OR REPLACE EXTERNAL TABLE nytaxi.external_green_tripdata
OPTIONS (
  format = 'parquet',
  uris = ['gs://de-zoomcamp_bucket02/green_tripdata*'],
  eschema = auto_detect
)


CREATE OR REPLACE TABLE nytaxi.yellow_tripdata 
as
SELECT * FROM nytaxi.external_yellow_tripdata

CREATE OR REPLACE TABLE nytaxi.green_tripdata
as
SELECT * FROM nytaxi.external_green_tripdata

select count(*) from nytaxi.yellow_tripdata
select count(*) from nytaxi.green_tripdata