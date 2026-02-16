CREATE OR REPLACE EXTERNAL TABLE ny_taxi_fhv.external_tripdata_2019
OPTIONS (
  format= 'csv',
  uris= ['gs://de-zoomcamp_bucket02_fhv/fhv_tripdata*']
);

CREATE OR REPLACE TABLE ny_taxi_fhv.tripdata_2019
AS
select * from ny_taxi_fhv.external_tripdata_2019;