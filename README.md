# Air Quality Comparison of Mexico City, Monterrey, and Guadalajara - Mexico
This project's objective is to acquire air pollutants time series evolution of these big cities from Mexico, compare these independent groups to make statistical claims and leverage time-series algorithms for forecasting.

## Methodology
1. **Design, develop, and execute an ETL data pipeline**: Set a scheduler job using GitHub Actions, which extracts air pollutants information (***co,no2,pm10,pm25,o3,so2***) from [aqicn.org](https://aqicn.org/api/) every 4 hours of each day; transforms the cities' data into records using JSON; finally, loads it in an AWS DynamoDB table. 
2. **Create data analytics and compare cities' data**: Design an interactive dashboard using StreamLit to showcase the evolution of the distinct air pollutants in each of these cities. Conduct statistical analyses to conclude at current time, which of the selected cities present the most dangerous levels of air pollution. 
3. **Train Forecasting Time-Series models**: Leverage the stored data to train data models to forecast levels of air pollution for the upcoming days.

## Progress
**Milestone 1**: Online
**Milestone 2**: On Development
**Milestone 3**: Not Started


