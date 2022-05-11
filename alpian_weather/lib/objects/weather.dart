import 'package:intl/intl.dart';

class Weather {
  final String description;
  final double temperature;
  final int humidity;
  final String location;
  final String lastUpdated;
  final double minTemperature;
  final double maxTemperature;

  const Weather({
    required this.description,
    required this.temperature,
    required this.humidity,
    required this.location,
    required this.lastUpdated,
    required this.minTemperature,
    required this.maxTemperature,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      description: json['weather'][0]['description'],
      temperature: json['main']['temp'],
      humidity: json['main']['humidity'],
      location: json['name'],
      minTemperature: json['main']['temp_min'],
      maxTemperature: json['main']['temp_max'],
      lastUpdated: 'Last updated: ${DateFormat("HH:mm").format(DateTime.now())}',
    );
  }
}