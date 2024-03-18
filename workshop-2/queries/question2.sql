create materialized view number_of_trips as
with t as (
select 
		td.pulocationid,
		td.dolocationid,
		avg(td.tpep_dropoff_datetime - td.tpep_pickup_datetime) as avg_time,
		min(td.tpep_dropoff_datetime - td.tpep_pickup_datetime) as min_time,
		max(td.tpep_dropoff_datetime - td.tpep_pickup_datetime) as max_time
from
	trip_data td
group by 
		td.pulocationid,
		td.dolocationid
), max_avg as
(
	select
		max(avg_time) as max_avg_time
	from
		t)
select 
	td.pulocationid,
	td.dolocationid,
	(td.tpep_dropoff_datetime - td.tpep_pickup_datetime) as duration
from
	trip_data td, max_avg
where
	td.tpep_dropoff_datetime - td.tpep_pickup_datetime >= max_avg.max_avg_time;