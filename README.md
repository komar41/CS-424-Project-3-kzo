# Big Yellow Taxi

## Project Access

- **Demo URL:** [http://shiny.evl.uic.edu:3838/g5/CS-424-Project-3-kzo/](http://shiny.evl.uic.edu:3838/g5/CS-424-Project-3-kzo/)
- **Introduction video:** [https://www.youtube.com/watch?v=hREgA79KWEo](https://www.youtube.com/watch?v=hREgA79KWEo)
- **GitHub repo:** [https://github.com/komar41/Big-Yellow-Taxi](https://github.com/komar41/Big-Yellow-Taxi)
- **Tools used:** Python, Pandas, Numpy, R, and Shiny

The visualization was created for a screen with resolution of 5760x1620 (Sage screen of EVL UIC Lab).

<p>
  <img src="https://user-images.githubusercontent.com/90569118/164603472-22adce04-3812-4130-b927-c0cf9270b6d2.jpeg" alt="User interface displayed in SAGE screen of EVL lab, UIC">
</p>

## Introduction

This project visualizes trends and interesting patterns in Taxi ridership data (2019) in Chicago. We chose to look at data from 2019 as it is pre-COVID data and more representative of a 'typical' year.

## User Interface

<p>
  <img src="https://komar41.github.io/assets/img/projects/big_yellow_taxi/overview/Overview%201.png" alt="UI of Big Yellow Taxi application">
</p>

### Control Panel
![image](https://github.com/user-attachments/assets/fadd39f1-8138-439e-8eb6-04a52620bfcc)
- Community area selection (default: Chicago)
- Outside Chicago Area checkbox
- From/To radio buttons for specific community areas
- Time format selection (12-hour or 24-hour)
- Distance unit selection (Miles or Kilometers)
- Taxi company selection

### Graphs and Tables
1. Taxi rides by date
![image](https://github.com/user-attachments/assets/b43c7018-d7f3-4556-9564-4f9ea6230e1c)

2. Taxi rides by month
![image](https://github.com/user-attachments/assets/5ecf9b51-9e4b-492c-ab35-be212c06151c)

3. Taxi rides by day of week
![image](https://github.com/user-attachments/assets/c5e71551-9f48-4089-9424-341fbebcf8e1)

4. Taxi rides by hour of day
![image](https://github.com/user-attachments/assets/41ca03b3-ffdf-4b14-8b63-d3c770b95dba)

5. Taxi rides by trip distance
![image](https://github.com/user-attachments/assets/ea5a9d99-d2cd-4751-ae14-b48cf1918b9a)

6. Taxi rides by trip duration
![image](https://github.com/user-attachments/assets/0c5b4fdb-d20d-411c-9f04-155565c6ad7d)

7. Percentage of taxi rides from one neighborhood to all others
![image](https://github.com/user-attachments/assets/d87d505a-823f-4e21-84e6-936fa882c427)

### Map Visualization
- Heat map representation of ridership data per community
- Legends for percentage ranges
- Hover functionality for community area information
![image](https://github.com/user-attachments/assets/f6d7d054-dc4b-4827-aa0f-8c130089ff2a)

### About Page
![image](https://github.com/user-attachments/assets/fca5ecc5-0cce-42a3-bd7d-406e60b27a7d)

## About the Data
Data sources from Chicago Data Portal:
1. [Taxi Trips in Chicago for 2019](https://data.cityofchicago.org/Transportation/Taxi-Trips-2019/h4cq-z3dy) (7GB)
2. [Boundaries - Community Areas](https://data.cityofchicago.org/Facilities-Geographic-Boundaries/Boundaries-Community-Areas-current-/cauq-8yn6) (2MB)

### Data Usage
From the taxi trips dataset, we use 6 out of 23 columns:
- Trip Start Timestamp
- Trip Seconds
- Trip Miles
- Pickup Community Area
- Dropoff Community Area
- Company

The Boundaries dataset provides information about community area boundaries in Chicago, used for map visualization.

### Data Processing
Due to shiny-server limitations, we split the data into various subfolders with CSV files. A Python script was used for preprocessing and splitting the data.

## Interesting Findings

1. When looking at all community area in Chicago, I find it interesting that there are some gaps during the end of January, the start of April, the end of May, the start of July, the start of September, and the end of November. There are also minor gaps in the graph which might be because of low ridership during weekends.
![image](https://github.com/user-attachments/assets/d3040238-b07d-410d-a0df-f520bb98e438)

2. Looking at this insight backs up our theory about the second part of insight 1. There are low ridership data in Chicago during weekends and highest ridership on Thursdays and Fridays as can be seen on the bar graph and data table.
![image](https://github.com/user-attachments/assets/72092641-1452-4482-bc5f-4622ad54f0ef)

3. Here we are looking data from only the Loop. When we look at 8 AM, 9 AM, 4 PM and 5 PM, there is a relative spike in ridership compared to the other times around those specific time of the day. This can be explained by the fact that those are rush-hour times.
![image](https://github.com/user-attachments/assets/781dc591-ffd4-4f86-bee5-8e277743dfaf)

4. Here we are looking at data from only the Loop. The majority of the rides are between 0.8 and 2 Kilometers. This might be because the customers are mostly traveling within the loop.
![image](https://github.com/user-attachments/assets/b7ca5224-9d44-450f-800d-bb5143deb777)

5. Here we are looking at data from only the Loop. The majority of the rides are between 5 and 10 minutes. This furthermore supports our claims from insight 4 that most of the riders in the loop are traveling small distances and possibly within the loop.
![image](https://github.com/user-attachments/assets/76f7ec9a-fd26-4d11-a377-b20587e6ea4c)

6. Here we are looking at data from only the Loop. The previous two insights can be furthermore supported as about 1/4 of the riders are traveling within the loop.
![image](https://github.com/user-attachments/assets/7def6d9b-7b45-4872-8ed1-27f673b0a9dc)

## Team
- Kazi Shahrukh Omar
- Akash Magnadia

