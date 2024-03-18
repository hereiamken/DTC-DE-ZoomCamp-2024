with t as (
select
	MAX(tpep_pickup_datetime) as tpep_pickup_time
from
	trip_data
),
latest_pickup_time as (
select
	tpep_pickup_time - interval '17 hours' as tpep_pickup_datetime_17h_before,
	tpep_pickup_time as tpep_pickup_datetime_now
from
	t),
most_3_busiest_zones as (
select
	pulocationid,
	count(pulocationid) as cnt
from
	trip_data,
	latest_pickup_time
where
	tpep_pickup_datetime >= latest_pickup_time.tpep_pickup_datetime_17h_before
	and tpep_pickup_datetime <= latest_pickup_time.tpep_pickup_datetime_now
group by
	pulocationid
order by
	count(pulocationid) desc
limit 3)
select
	tz."zone"
from
	most_3_busiest_zones m
join taxi_zone tz on
	tz.location_id = m.pulocationid;