import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

class Forecast {
  final String description;
  final String temperature;
  final int humidity;
  final String minTemperature;
  final String maxTemperature;
  final String iconId;
  final DateTime date;

  const Forecast(
      {required this.description,
      required this.temperature,
      required this.humidity,
      required this.minTemperature,
      required this.maxTemperature,
      required this.iconId,
      required this.date});

  factory Forecast.fromJson(Map<String, dynamic> json) {
    return Forecast(
        description: json['weather'][0]['main'],
        temperature: json['main']['temp'].toString().substring(0, 2),
        humidity: json['main']['humidity'],
        minTemperature: json['main']['temp_min'].toString().substring(0, 2),
        maxTemperature: json['main']['temp_max'].toString().substring(0, 2),
        iconId: json['weather'][0]['icon'].toString().substring(0, 2),
        date: DateTime.parse(json['dt_txt']));
  }
}
