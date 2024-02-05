import pandas as pd
if 'transformer' not in globals():
    from mage_ai.data_preparation.decorators import transformer
if 'test' not in globals():
    from mage_ai.data_preparation.decorators import test


@transformer
def transform(data, *args, **kwargs):
    """
    Specify your transformation logic here
    """
    # Convert from camel case to snake case
    data.columns = (data.columns
                    .str.replace('(?<=[a-z])(?=[A-Z])', '_', regex=True)
                    .str.lower()
                    )
    # data['lpep_pickup_date'] = pd.to_datetime(data['lpep_pickup_datetime'], unit='s').dt.date

    # filter rows with passenger count is zero
    zero_passengers_df = data[data['passenger_count'].isin([0])]
    print("Total trips with zero passengers is: ",
          zero_passengers_df['passenger_count'].count())

    # filter rows with trips's distance is zero
    zero_trip_distance_df = data[data['trip_distance'].isin([0])]
    print("Total trips with zero trip distance is: ",
          zero_trip_distance_df['trip_distance'].count())

    return data[(data['passenger_count'] > 0) & (data['trip_distance'] > 0)]


@test
def test_vendor_id_column_existed(output, *args) -> None:
    assert 'vendor_id' in output.columns, 'This is vendor_id column existed in output'


@test
def test_passenger_count_zero(output, *args) -> None:
    assert output['passenger_count'].isin(
        [0]).sum() == 0, 'There are rides with zero passengers'


@test
def test_trip_distance_zero(output, *args) -> None:
    assert output['trip_distance'].isin([0]).sum(
    ) == 0, 'There are rides with zero trip distance'
