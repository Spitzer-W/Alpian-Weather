import 'package:intl/intl.dart';

class Forecast {
  final String description;
  final double temperature;
  final int humidity;
  final double minTemperature;
  final double maxTemperature;

  const Forecast({
    required this.description,
    required this.temperature,
    required this.humidity,
    required this.minTemperature,
    required this.maxTemperature,
  });

  factory Forecast.fromJson(Map<String, dynamic> json) {
    return Forecast(
      description: json['list'][0]['weather'][0]['main'],
      temperature: json['list'][0]['main']['temp'],
      humidity: json['list'][0]['main']['humidity'],
      minTemperature: json['list'][0]['main']['temp_min'],
      maxTemperature: json['list'][0]['main']['temp_max'],
      );
  }
}