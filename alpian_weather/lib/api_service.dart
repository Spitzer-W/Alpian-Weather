import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'objects/Weather.dart';
import 'package:http/http.dart' as http;

import 'objects/forecast.dart';
import 'objects/hourlyforecast.dart';

class ApiService extends ChangeNotifier {
  late Future<Weather> futureWeather = fetchCurrentWeather();
  late Future<List<Forecast>> futureForecast = fetchFiveDayForecast();
  late Future<List<HourlyForecast>> futureHourly = fetchHourlyForecast();

  Future<Weather> fetchCurrentWeather() async {
    try {
      final response = await http.get(Uri.parse(
          'https://api.openweathermap.org/data/2.5/weather?lat=51.509865&lon=-0.118092&units=metric&appid=4dfc56c59d987fa85a9c1602e29e74a5'));

      if (response.statusCode == 200) {
        // notifyListeners();
        // await DatabaseHandler()
        //     .insertWeather(Weather.fromJson(jsonDecode(response.body)));

        // var temp = await DatabaseHandler().getCurrentWeather();
        Weather weather = Weather.fromJson(jsonDecode(response.body));
        print('Last Updated: ${weather.lastUpdated}');
        return weather;
      } else {
        throw Exception('Failed to fetch weather data');
      }
    } catch (exception) {
      print('Exception thrown fetching current weather: $exception');

      return Weather(
          temperature: 0,
          iconId: '?',
          description: '?',
          humidity: 0,
          location: '?',
          minTemperature: 0,
          maxTemperature: 0,
          lastUpdated:
              'Last updated: ${DateFormat("dd-EEE-yyyy HH:mm:ss a").format(DateTime.now())}');
    } finally {
      notifyListeners();
    }
  }

  Future<List<Forecast>> fetchFiveDayForecast() async {
    List<Forecast> forecast = [];

    try {
      final response = await http.get(Uri.parse(
          'https://api.openweathermap.org/data/2.5/forecast?lat=51.509865&lon=-0.118092&units=metric&appid=4dfc56c59d987fa85a9c1602e29e74a5'));

      if (response.statusCode == 200) {
        var decode = jsonDecode(response.body);
        var list = decode['list'];

        for (int i = 0; i < list.length; i++) {
          forecast.add(Forecast(
              description: list[i]['weather'][0]['main'],
              temperature: list[i]['main']['temp'].toDouble(),
              humidity: list[i]['main']['humidity'],
              minTemperature: list[i]['main']['temp_min'].toDouble(),
              maxTemperature: list[i]['main']['temp_max'].toDouble(),
              iconId: list[i]['weather'][0]['icon'].toString().substring(0, 2),
              date: DateTime.parse(list[i]['dt_txt'].toString())));
        }
        return forecast;
      } else {
        throw Exception('Failed to fetch weather data');
      }
    } catch (exception) {
      print('Exception thrown fetching 5 day forecast: $exception');

      return [];
    }
  }

  Future<List<HourlyForecast>> fetchHourlyForecast() async {
    List<HourlyForecast> hourlyForecast = [];

    try {
      final response = await http.get(Uri.parse(
          'https://api.openweathermap.org/data/2.5/onecall?lat=51.509865&lon=-0.118092&units=metric&appid=4dfc56c59d987fa85a9c1602e29e74a5'));

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        var hourlyList = data['hourly'];
        for (int i = 0; i < 24; i++) {
          hourlyForecast.add(HourlyForecast(
              temperature: hourlyList[i]['temp'].toString(),
              iconId: hourlyList[i]['weather'][0]['icon']
                  .toString()
                  .substring(0, 2)));
        }
        return hourlyForecast;
      } else {
        throw Exception('Failed to fetch hourly weather data');
      }
    } catch (exception) {
      print('Exception thrown fetching current hourly weather: $exception');

      // Display fake set of data
      for (int i = 0; i < 40; i++) {
        hourlyForecast.add(HourlyForecast(
            temperature: '${Random().nextInt(25)}', iconId: '01'));
      }
      return hourlyForecast;
    }
  }
}
