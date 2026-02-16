with trips as (
    select * from {{ ref('fct_trips') }}
),
dim_zones as (
    select * from {{ ref('dim_zones') }}
)
select
    trips.service_type,
    trips.pickup_zone,
    dim_zones.zone as pickup_zone_name,
    date_trunc(trips.pickup_datetime, month) as revenue_month,
    sum(trips.total_amount) as monthly_total_amount,
    count(*) as total_monthly_trips
from trips
inner join dim_zones
    on trips.pickup_location_id = dim_zones.location_id
group by 1,2,3,4