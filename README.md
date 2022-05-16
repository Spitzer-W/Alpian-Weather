# Alpian-Weather

<img width="200" alt="Screenshot 2022-05-16 at 12 22 38" src="https://user-images.githubusercontent.com/52418829/168598742-5b40894b-e425-4cc4-b12d-59a3edd65ffc.png">

## Description
This purpose of this project is to build a simple flutter application that displays the current weather info in London and the weather forecasts for the next 5 days. The final user should also be able to refresh the view by pressing on a button located in the app bar.

This will be achieved using the open weather map API that can be found here: https://openweathermap.org/
For this project we will be making use of the following endpoints:
- https://openweathermap.org/current
- https://openweathermap.org/forecast5
- https://openweathermap.org/api/one-call-api

## Table of Contents
- [Current](#current)
- [Forecast5](#forecast5)
- [Hourly](#hourly)
- [Improvements](#improvments)

## Current
I use the API call specified in the https://openweathermap.org/current endpoint to fetch the latest weather data with the following parameters:
- q => is the city we want to check; London
- units => is the type we want returned for measurements; metric
- appId => the API key we registered

I then map the json data to a Weather object defined with the following properties:
  - String description;
  - String iconId;
  - double temperature;
  - int humidity;
  - String location;
  - String lastUpdated;
  - double minTemperature;
  - double maxTemperature;

<img width="886" alt="Screenshot 2022-05-16 at 12 22 38" src="https://user-images.githubusercontent.com/52418829/168582255-d818fe0d-e7c2-4e3b-8ec7-fc621888039c.png">


## Forecast5
I use the API call specified in the https://openweathermap.org/forecast5 endpoint to fetch the latest forecast data with the following parameters:
- q => is the city we want to check; London
- units => is the type we want returned for measurements; metric
- appId => the API key we registered

I then map the json data to a Forecast object defined with the following properties:
  - String description;
  - String temperature;
  - int humidity;
  - String minTemperature;
  - String maxTemperature;
  - String iconId;
  - DateTime date;
  
<img width="891" alt="Screenshot 2022-05-16 at 12 37 31" src="https://user-images.githubusercontent.com/52418829/168584455-9ae34f9c-3b33-4e3b-afd7-f4caa60034f3.png">


## Hourly
This feature was included as a bonus as I felt it served a better purpose to the user and would have more of a practical use.

While implementing the hourly forecast I found that this endpoint also returns all of the data required for both of the above features so the same could be achieved with 1 get request.

This endpoint provides the following data:
- Current weather
- Minute forecast for 1 hour
- Hourly forecast for 48 hours
- Daily forecast for 7 days
- National weather alerts
- Historical weather data for the previous 5 days

I use the API call specified in the https://openweathermap.org/one-call-api endpoint to fetch the latest forecast data with the following parameters:
- lat => is the latitude we want to check; 51.509865
- lon => is the longitude we want to check; -0.118092
- units => is the type we want returned for measurements; metric
- appId => the API key we registered

I then map the json data to a HourlyForecast object defined with the following properties:
  - String temperature;
  - String iconId;
  - DateTime time;

<img width="1018" alt="Screenshot 2022-05-16 at 14 19 50" src="https://user-images.githubusercontent.com/52418829/168601879-b9f1bd4f-f122-48ce-8296-b766752002b1.png">


## Improvements
While I am quite happy with the progress I made during this project there will always be room for improvement.

As such, I feel that I would have liked to have done the following:

### Local Storage
This would have been a great feature to add as it would have provided additional offline support if the weather data had been fetched prior.
Sadly I did not managed to get the Sqflite library working the way I had intended which meant that I did not have offline capabilities.

### Provider
This would have also been a very nice feature to demonstrate as state management plays a big part in any flutter application. I did understand the concept and had a go at implementing a ChangeNotifer, but sadly I could not get it working the way I had envisioned so I stuck with setState so the refresh button actually worked.

### Unit Tests
I am rather disappointed for not including any unit tests or ui tests, again I had a go at implmenting them but it was at this point I started to notice flaws in the way I had implemented other things so thought it was best to stick with them. 



