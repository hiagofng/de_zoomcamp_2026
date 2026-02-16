with source as (
        select * from {{ source('raw_data', 'taxi_zone_lookup') }}
  ),
  renamed as (
      select
          {{ adapter.quote("LocationID") }},
        {{ adapter.quote("Borough") }},
        {{ adapter.quote("Zone") }},
        {{ adapter.quote("service_zone") }}

      from source
  )
  select * from renamed
    