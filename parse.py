import os
import numpy as np
import pandas as pd
import csv
from datetime import datetime
import warnings
warnings.filterwarnings("ignore")

def mkdir(dir):
    if not os.path.exists(dir):
        os.mkdir(dir)

def preprocess(df, dictCompany):

    df = df[['Trip Seconds', 'Trip Miles', 'Pickup Community Area', 'Dropoff Community Area', 'Company', 'Trip Start Timestamp']]
    df = df[(df['Trip Miles']>=0.5) & (df['Trip Miles']<=100)]
    df['tripKM'] = df['Trip Miles'].apply(lambda x: round(x*1.609,2))
    df = df[(df['Trip Seconds']>=60) & (df['Trip Seconds']<=18000)]
    df['Pickup Community Area'] = df['Pickup Community Area'].mask( ~((df['Pickup Community Area']>=1) & (df['Pickup Community Area']<=77)), 78)
    df['Dropoff Community Area'] = df['Dropoff Community Area'].mask( ~((df['Dropoff Community Area']>=1) & (df['Dropoff Community Area']<=77)), 78)
    df = df[~((df['Pickup Community Area']==78) & (df['Dropoff Community Area']==78))]
    df = df.replace({"Company": dictCompany})
    df = df.dropna()
    df['Trip Start Timestamp'] = pd.to_datetime(df['Trip Start Timestamp'])
    df['Trip Start Timestamp'] = df['Trip Start Timestamp'].apply(lambda x: pd.datetime(x.year, x.month, x.day, x.hour, 0, 0))
    df['Pickup Community Area'] = df['Pickup Community Area'].astype(int)
    df['Dropoff Community Area'] = df['Dropoff Community Area'].astype(int)
    df['Trip Seconds'] = df['Trip Seconds'].astype(int)
    df = df.rename(columns={'Trip Seconds': 'tripSeconds', 'Trip Miles': 'tripMiles', 'Pickup Community Area': 'pickupArea', 'Dropoff Community Area': 'dropArea', 'Company': 'company', 'Trip Start Timestamp': 'tripStartTime'})

    return df


def preCalc(df, str, drop=False, pick=False, outChicago=False):
    
    df_date = df.groupby([df['tripStartTime'].dt.date]).size().to_frame().reset_index().rename(columns={'tripStartTime': 'Date',0: 'Count'})
    df_hour = df.groupby([df['tripStartTime'].dt.hour]).size().to_frame().reset_index().rename(columns={'tripStartTime': 'Hour', 0: 'Count'})
    df_day = df.groupby([df['tripStartTime'].dt.dayofweek]).size().to_frame().reset_index().rename(columns={'tripStartTime': 'Day', 0: 'Count'})
    
     # Values: 0 to 6. (0: Monday, 6: Sunday)
    df_month = df.groupby([df['tripStartTime'].dt.month]).size().to_frame().reset_index().rename(columns={'tripStartTime': 'Month', 0: 'Count'})

    df_mileage_miles = df
    ranges_miles = [0.49, 1, 3, 5, 10, 15, 20, 100]
    df_mileage_miles['mileage_bin_miles'] = pd.cut(df['tripMiles'], bins=ranges_miles)
    df_mileage_miles = df_mileage_miles.groupby([df_mileage_miles['mileage_bin_miles']]).size().to_frame().reset_index().rename(columns={'mileage_bin_miles': 'Mileage_miles', 0: 'Count'})
    df_mileage_miles.sort_values(by='Mileage_miles')
    labels = ['0.5 - 1', '1 - 3', '3 - 5', '5 - 10', '10 - 25', '15 - 20', '20 - 100']
    df_mileage_miles['Mileage_miles'] = df_mileage_miles['Mileage_miles'].cat.rename_categories(labels)

    df_mileage_km = df
    ranges_km  = [0.79, 1.6, 4.8, 8.0, 16.0, 24.0, 32.0, 160.0]
    df_mileage_km['mileage_bin_km'] = pd.cut(df['tripKM'], bins=ranges_km)
    df_mileage_km = df_mileage_km.groupby([df_mileage_km['mileage_bin_km']]).size().to_frame().reset_index().rename(columns={'mileage_bin_km': 'Mileage_km', 0: 'Count'})
    df_mileage_km.sort_values(by='Mileage_km')
    labels = ['0.8 - 1.6', '1.6 - 4.8', '4.8 - 8', '8 - 16', '16 - 24', '24 - 32', '32 - 160']
    df_mileage_km['Mileage_km'] = df_mileage_km['Mileage_km'].cat.rename_categories(labels)

    df_time = df
    ranges = [59.99, 300, 600, 900, 1200, 1800, 3600, np.inf]
    df_time['time_bin'] = pd.cut(df['tripSeconds'], bins=ranges)
    df_time = df_time.groupby([df_time['time_bin']]).size().to_frame().reset_index().rename(columns={'time_bin': 'timeTaken', 0: 'Count'})
    df_time.sort_values(by='timeTaken')
    labels = ['1 - 5 min', '5 - 10 min', '10 - 15 min', '15 - 20 min', '20 - 30 min', '1/2 hr - 1 hr',  '> 1 hr']
    df_time.timeTaken = df_time.timeTaken.cat.rename_categories(labels)

    df_date.to_csv(str+'date.csv', index=False)
    df_hour.to_csv(str+'hour.csv', index=False)
    df_day.to_csv(str+'day.csv', index=False)
    df_month.to_csv(str+'month.csv'.format(str), index=False)
    df_mileage_miles.to_csv(str+'mileage_miles.csv'.format(str), index=False)
    df_mileage_km.to_csv(str+'mileage_km.csv'.format(str), index=False)
    df_time.to_csv(str+'time.csv'.format(str), index=False)

    if(drop):
        dfDrop = df.groupby([df['dropArea']]).size().to_frame().reset_index().rename(columns={0: 'Percentage'})
        dfDrop['Percentage'] = round((100. * dfDrop['Percentage'] / dfDrop['Percentage'].sum()),2)
        if(outChicago):
            n=79
        else:
            n=78
        for i in range(1,n):
            if(i not in dfDrop['dropArea'].tolist()):
                add = {'dropArea':i, 'Percentage':0}
                dfDrop = dfDrop.append(add, ignore_index = True)

        dfDrop = dfDrop.sort_values(by=['dropArea'],ignore_index=True)
        dfDrop.to_csv(str+'drop.csv'.format(str), index=False)

    if(pick):
        dfPick = df.groupby([df['pickupArea']]).size().to_frame().reset_index().rename(columns={0: 'Percentage'})
        dfPick['Percentage'] = round((100. * dfPick['Percentage'] / dfPick['Percentage'].sum()),2)
        if(outChicago):
            n=79
        else:
            n=78
        for i in range(1,n):
            if(i not in dfPick['pickupArea'].tolist()):
                add = {'pickupArea':i, 'Percentage':0}
                dfPick = dfPick.append(add, ignore_index = True)

        dfPick = dfPick.sort_values(by=['pickupArea'],ignore_index=True)
        dfPick.to_csv(str+'pick.csv'.format(str), index=False)