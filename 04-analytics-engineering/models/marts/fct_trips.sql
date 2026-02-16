with trips as (
    select * from {{ ref('int_trips_unioned') }}
),
dim_zones as (
    select * from {{ ref('dim_zones') }}
)

select
    -- ids
    trips.vendor_id,
    trips.rate_code_id,
    trips.pickup_location_id,
    trips.dropoff_location_id,

    -- zone info (joined)
    pickup_zone.borough as pickup_borough,
    pickup_zone.zone as pickup_zone,
    dropoff_zone.borough as dropoff_borough,
    dropoff_zone.zone as dropoff_zone,

    -- timestamps
    trips.pickup_datetime,
    trips.dropoff_datetime,

    -- derived: trip duration in minutes
    timestamp_diff(trips.dropoff_datetime, trips.pickup_datetime, minute) as trip_duration_minutes,

    -- trip info
    trips.passenger_count,
    trips.trip_distance,
    trips.trip_type,
    trips.store_and_fwd_flag,

    -- payment
    trips.payment_type,
    trips.fare_amount,
    trips.extra,
    trips.mta_tax,
    trips.tip_amount,
    trips.tolls_amount,
    trips.ehail_fee,
    trips.improvement_surcharge,
    trips.total_amount,

    -- service type
    trips.service_type

from trips
left join dim_zones as pickup_zone
    on trips.pickup_location_id = pickup_zone.location_id
left join dim_zones as dropoff_zone
    on trips.dropoff_location_id = dropoff_zone.location_id