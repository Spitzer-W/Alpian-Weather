class HourlyForecast {
  final String temperature;
  final String iconId;
  final DateTime time;

  HourlyForecast(
      {required this.temperature, required this.iconId, required this.time});

  factory HourlyForecast.fromJson(Map<String, dynamic> json) {
    return HourlyForecast(
        temperature: json['temp'].toString().substring(0, 2),
        iconId: json['weather'][0]['icon'].toString().substring(0, 2),
        time: DateTime.fromMillisecondsSinceEpoch(json['dt'] * 1000));
  }
}
