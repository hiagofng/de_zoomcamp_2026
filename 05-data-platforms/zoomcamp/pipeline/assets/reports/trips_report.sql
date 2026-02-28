/* @bruin

name: reports.trips_report
type: duckdb.sql

depends:
  - staging.trips

materialization:
  type: table
  strategy: time_interval
  incremental_key: pickup_date
  time_granularity: date

columns:
  - name: pickup_date
    type: date
    description: Date of pickup
    primary_key: true
    checks:
      - name: not_null
  - name: taxi_type
    type: varchar
    description: Type of taxi (yellow or green)
    primary_key: true
    checks:
      - name: not_null
  - name: payment_type_name
    type: varchar
    description: Human-readable payment type
    primary_key: true
  - name: trip_count
    type: bigint
    description: Number of trips
    checks:
      - name: non_negative
  - name: total_passengers
    type: float
    description: Sum of passenger counts
    checks:
      - name: non_negative
  - name: total_distance
    type: float
    description: Sum of trip distances in miles
    checks:
      - name: non_negative
  - name: total_fare
    type: float
    description: Sum of fare amounts
  - name: total_amount
    type: float
    description: Sum of total amounts charged

@bruin */

SELECT
    CAST(pickup_datetime AS DATE) AS pickup_date,
    taxi_type,
    payment_type_name,
    COUNT(*) AS trip_count,
    SUM(passenger_count) AS total_passengers,
    SUM(trip_distance) AS total_distance,
    SUM(fare_amount) AS total_fare,
    SUM(total_amount) AS total_amount
FROM staging.trips
WHERE pickup_datetime >= '{{ start_datetime }}'
  AND pickup_datetime < '{{ end_datetime }}'
GROUP BY
    CAST(pickup_datetime AS DATE),
    taxi_type,
    payment_type_name
