CREATE OR REPLACE EXTERNAL TABLE nytaxi.external_yellow_tripdata
OPTIONS (
  format = 'csv',
  uris = ['gs://de-zoomcamp_bucket02/yellow_tripdata*']
);

CREATE OR REPLACE TABLE nytaxi.yellow_tripdata 
AS
select * from nytaxi.external_yellow_tripdata;

CREATE OR REPLACE EXTERNAL TABLE nytaxi.external_green_tripdata
OPTIONS (
  format = 'csv',
  uris = ['gs://de-zoomcamp_bucket02/green_tripdata*']
);

CREATE OR REPLACE TABLE nytaxi.green_tripdata 
AS
select * from nytaxi.external_green_tripdata;