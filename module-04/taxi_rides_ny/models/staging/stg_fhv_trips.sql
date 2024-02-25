{{ config(materialized="view") }}

with
    tripdata as (
        select
            *,
            row_number() over (partition by dispatching_base_num, pickup_datetime) as rn
        from {{ source("staging", "fhv_trips") }}
        where dispatching_base_num is not null
    )
select
    -- identifiers
    {{ dbt_utils.generate_surrogate_key(["dispatching_base_num", "pickup_datetime"]) }}
    as tripid,
    {{ dbt.safe_cast("PUlocationID", api.Column.translate_type("integer")) }}
    as pulocationid,
    {{ dbt.safe_cast("DOlocationID", api.Column.translate_type("integer")) }}
    as dolocationid,

    -- timestamps
    cast(pickup_datetime as timestamp) as pickup_datetime,
    cast(dropOff_datetime as timestamp) as dropoff_datetime,

    -- payment info
    cast(SR_Flag as numeric) as sr_flag,
    cast(Affiliated_base_number as string) as affiliated_base_number
from tripdata
where rn = 1

-- dbt build --select <model_name> --vars '{'is_test_run': 'false'}'
{% if var("is_test_run", default=true) %} limit 100 {% endif %}
