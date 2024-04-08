import pyspark.sql.types as T

INPUT_DATA_PATH = 'resources/green_tripdata_2019-10.csv.gz'
BOOTSTRAP_SERVERS = 'localhost:9092'

TOPIC_WINDOWED_VENDOR_ID_COUNT = 'vendor_counts_windowed'

PRODUCE_TOPIC_GREEN_TRIPS = CONSUME_TOPIC_GREEN_TRIPS = 'green-trips'

RIDE_SCHEMA = T.StructType(
    [T.StructField('lpep_pickup_datetime', T.TimestampType()),
     T.StructField('lpep_dropoff_datetime', T.TimestampType()),
     T.StructField("PULocationID", T.IntegerType()),
     T.StructField("DOLocationID", T.FloatType()),
     T.StructField("passenger_count", T.IntegerType()),
     T.StructField("trip_distance", T.FloatType()),
     T.StructField("tip_amount", T.FloatType()),
     ])
