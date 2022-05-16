import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

class Forecast {
  final String description;
  final double temperature;
  final int humidity;
  final double minTemperature;
  final double maxTemperature;
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
        description: json['list'][0]['weather'][0]['main'],
        temperature: json['list'][0]['main']['temp'],
        humidity: json['list'][0]['main']['humidity'],
        minTemperature: json['list'][0]['main']['temp_min'],
        maxTemperature: json['list'][0]['main']['temp_max'],
        iconId:
            json['list'][0]['weather'][0]['icon'].toString().substring(0, 2),
        date: DateTime.parse(json['list'][0]['dt_txt'].toString()));
  }
}
