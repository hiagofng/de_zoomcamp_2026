/* @bruin

name: staging.trips
type: duckdb.sql

depends:
  - ingestion.trips
  - ingestion.payment_lookup

materialization:
  type: table
  strategy: time_interval
  incremental_key: pickup_datetime
  time_granularity: timestamp

columns:
  - name: trip_id
    type: varchar
    description: Unique trip identifier (hash of key columns)
    primary_key: true
    nullable: false
    checks:
      - name: not_null
      - name: unique
  - name: pickup_datetime
    type: timestamp
    description: Standardized pickup timestamp
    checks:
      - name: not_null
  - name: dropoff_datetime
    type: timestamp
    description: Standardized dropoff timestamp
    checks:
      - name: not_null
  - name: taxi_type
    type: varchar
    description: Type of taxi (yellow or green)
    checks:
      - name: not_null
      - name: accepted_values
        value:
          - yellow
          - green
  - name: passenger_count
    type: float
    description: Number of passengers
  - name: trip_distance
    type: float
    description: Trip distance in miles
    checks:
      - name: non_negative
  - name: pu_location_id
    type: integer
    description: Pickup location zone ID
  - name: do_location_id
    type: integer
    description: Dropoff location zone ID
  - name: payment_type_id
    type: integer
    description: Payment type code
  - name: payment_type_name
    type: varchar
    description: Human-readable payment type name
  - name: fare_amount
    type: float
    description: Fare amount in dollars
  - name: total_amount
    type: float
    description: Total amount charged

custom_checks:
  - name: no_duplicate_trips
    description: Ensure no duplicate trip_id values exist
    query: |
      SELECT COUNT(*) - COUNT(DISTINCT trip_id)
      FROM staging.trips
      WHERE pickup_datetime >= '{{ start_datetime }}'
        AND pickup_datetime < '{{ end_datetime }}'
    value: 0

@bruin */

WITH source AS (
    SELECT
        *,
        COALESCE(tpep_pickup_datetime, lpep_pickup_datetime) AS pickup_datetime,
        COALESCE(tpep_dropoff_datetime, lpep_dropoff_datetime) AS dropoff_datetime,
        ROW_NUMBER() OVER (
            PARTITION BY
                taxi_type,
                COALESCE(tpep_pickup_datetime, lpep_pickup_datetime),
                COALESCE(tpep_dropoff_datetime, lpep_dropoff_datetime),
                pu_location_id,
                do_location_id,
                fare_amount,
                total_amount
            ORDER BY extracted_at DESC
        ) AS row_num
    FROM ingestion.trips
    WHERE COALESCE(tpep_pickup_datetime, lpep_pickup_datetime) >= '{{ start_datetime }}'
      AND COALESCE(tpep_pickup_datetime, lpep_pickup_datetime) < '{{ end_datetime }}'
),

deduplicated AS (
    SELECT * FROM source WHERE row_num = 1
)

SELECT
    md5(
        CAST(d.taxi_type AS VARCHAR) || '-' ||
        CAST(d.pickup_datetime AS VARCHAR) || '-' ||
        CAST(d.dropoff_datetime AS VARCHAR) || '-' ||
        CAST(d.pu_location_id AS VARCHAR) || '-' ||
        CAST(d.do_location_id AS VARCHAR) || '-' ||
        CAST(d.fare_amount AS VARCHAR) || '-' ||
        CAST(d.total_amount AS VARCHAR)
    ) AS trip_id,
    d.pickup_datetime,
    d.dropoff_datetime,
    d.taxi_type,
    d.passenger_count,
    d.trip_distance,
    d.pu_location_id,
    d.do_location_id,
    CAST(d.payment_type AS INTEGER) AS payment_type_id,
    p.payment_type_name,
    d.fare_amount,
    d.total_amount
FROM deduplicated d
LEFT JOIN ingestion.payment_lookup p
    ON CAST(d.payment_type AS INTEGER) = p.payment_type_id
