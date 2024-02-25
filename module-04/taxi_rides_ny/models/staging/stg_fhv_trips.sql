{{ config(materialized="view") }}

with
    tripdata as (
        select
            *
        from {{ source("staging", "fhv_trips") }}
        where dispatching_base_num is not null
        and pickup_datetime is not null
        and extract(year from timestamp_micros(cast(pickup_datetime/1000 as int64))) = 2019
    )
select
    -- identifiers
    -- {{ dbt_utils.generate_surrogate_key(["dispatching_base_num", "pickup_datetime"]) }}
    -- as tripid,
    {{ dbt.safe_cast("PUlocationID", api.Column.translate_type("integer")) }}
    as pulocationid,
    {{ dbt.safe_cast("DOlocationID", api.Column.translate_type("integer")) }}
    as dolocationid,
    cast(dispatching_base_num as string) as dispatching_base_num,

    -- timestamps
    timestamp_micros(cast(pickup_datetime/1000 as int64)) as pickup_datetime,
    timestamp_micros(cast(dropOff_datetime/1000 as int64)) as dropoff_datetime,

    -- other info
    cast(SR_Flag as numeric) as sr_flag,
    cast(Affiliated_base_number as string) as affiliated_base_number
from tripdata

-- dbt build --select <model_name> --vars '{'is_test_run': 'false'}'
{% if var("is_test_run", default=true) %} limit 100 {% endif %}
