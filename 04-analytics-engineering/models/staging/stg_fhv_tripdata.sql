select 
    --identifiers
    dispatching_base_num as dispatching_base_num,

    --timestamps
    pickup_datetime as pickup_datetime,
    dropOff_datetime as dropoff_datetime,
    
    --trip info
    PUlocationID as pickup_location_id,
    DOlocationID as dropoff_location_id,
    SR_Flag as store_and_fwd_flag,
    Affiliated_base_number as affiliated_base_number,

from {{ source ('fhv_raw_data', 'tripdata_2019') }}
where dispatching_base_num is not null