create materialized view highest_average_trip_time as
with t as (
	select 
		td.pulocationid,
		td.dolocationid,
		avg(td.tpep_dropoff_datetime - td.tpep_pickup_datetime) as avg_time,
		min(td.tpep_dropoff_datetime - td.tpep_pickup_datetime) as min_time,
		max(td.tpep_dropoff_datetime - td.tpep_pickup_datetime) as max_time
	from trip_data td 
	group by 
		td.pulocationid,
		td.dolocationid
), max_avg as (
	select max(avg_time) as max_avg_time from t
)
select 
	t.pulocationid, 
	(select tz.zone from taxi_zone tz where cast(tz.location_id as bigint) = t.pulocationid limit 1) as pulocation_zone,
	t.dolocationid, 
	(select tz.zone from taxi_zone tz where cast(tz.location_id as bigint) = t.dolocationid limit 1) as dolocation_zone
from t, max_avg
where t.avg_time >= max_avg.max_avg_time;