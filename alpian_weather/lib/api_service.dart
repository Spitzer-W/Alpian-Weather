import 'dart:convert';
import 'dart:math';
import 'package:intl/intl.dart';
import 'objects/Weather.dart';
import 'package:http/http.dart' as http;

import 'objects/forecast.dart';
import 'objects/hourlyforecast.dart';

class ApiService {
  late Future<Weather> futureWeather = fetchCurrentWeather();
  late Future<List<Forecast>> futureForecast = fetchFiveDayForecast();
  late Future<List<HourlyForecast>> futureHourly = fetchHourlyForecast();

  Future<Weather> fetchCurrentWeather() async {
    try {
      final response = await http.get(Uri.parse(
          'https://api.openweathermap.org/data/2.5/weather?q=London&units=metric&appid=4dfc56c59d987fa85a9c1602e29e74a5'));

      if (response.statusCode == 200) {
        return Weather.fromJson(jsonDecode(response.body));
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
    }
  }

  Future<List<Forecast>> fetchFiveDayForecast() async {
    List<Forecast> forecast = [];

    try {
      final response = await http.get(Uri.parse(
          'https://api.openweathermap.org/data/2.5/forecast?q=London&units=metric&appid=4dfc56c59d987fa85a9c1602e29e74a5'));

      if (response.statusCode == 200) {
        var decode = jsonDecode(response.body);
        var list = decode['list'];

        for (int i = 0; i < list.length; i++) {
          var encode = jsonEncode(list[i]);
          forecast.add(Forecast.fromJson(jsonDecode(encode)));
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
          'https://api.openweathermap.org/data/2.5/onecall?lat=51.509865&lon=-0.118092&units=metric&appid=adc836d7741696e4bd5a9019f408a4c7'));

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        var hourlyList = data['hourly'];
        for (int i = 0; i < 24; i++) {
          var encode = jsonEncode(hourlyList[i]);
          hourlyForecast.add(HourlyForecast.fromJson(jsonDecode(encode)));
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
            temperature: '${Random().nextInt(25)}',
            iconId: '01',
            time: DateTime.now().add(Duration(hours: i))));
      }
      return hourlyForecast;
    }
  }
}
