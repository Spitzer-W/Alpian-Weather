import 'dart:async';
import 'dart:convert';
import 'package:alpian_weather/objects/Weather.dart';
import 'package:alpian_weather/objects/forecast.dart';
import 'package:alpian_weather/objects/hourlyforecast.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

late Future<Weather> futureWeather;
late Future<List<Forecast>> futureForecast;
late Future<List<HourlyForecast>> futureHourly;

class _MyAppState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();

    futureWeather = fetchCurrentWeather();
    futureForecast = fetchFiveDayForecast();
    futureHourly = fetchHourlyForecast();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Alpian Weather'), actions: [
        IconButton(
          icon: const Icon(Icons.refresh),
          onPressed: () {
            futureWeather = fetchCurrentWeather();
            futureForecast = fetchFiveDayForecast();
            futureHourly = fetchHourlyForecast();
            setState(() {});
          },
        ),
      ]),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.grey.shade800,
              Colors.black,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _CurrentDate(),
            _WeatherIcon(),
            _WeatherDescription(),
            _WeatherHumidity(),
            _LastUpdated(),
            _HourlyPrediction(),
            _FiveDayForecast(),
          ],
        ),
      ),
    );
  }
}

class _CurrentDate extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Center(
          child: Text(DateFormat("EEE MMM yyyy").format(DateTime.now()))),
    );
  }
}

class _WeatherIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: FutureBuilder<Weather>(
          future: futureWeather,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return getIcons(snapshot.data!.iconId, 80);
            } else {
              return const Icon(Icons.cloud, size: 80);
            }
          }),
    );
  }
}

class _WeatherDescription extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: FutureBuilder<Weather>(
          future: futureWeather,
          builder: (context, snapshot) {
            return snapshot.hasData
                ? Column(
                    children: [
                      Text(snapshot.data!.description),
                      RichText(
                          text: TextSpan(
                        style: const TextStyle(
                          fontSize: 70,
                          fontWeight: FontWeight.w100,
                        ),
                        children: [
                          TextSpan(text: '${snapshot.data!.temperature}'),
                          const WidgetSpan(
                              alignment: PlaceholderAlignment.top,
                              child: Padding(
                                padding: EdgeInsets.only(top: 10),
                                child:
                                    Text('c', style: TextStyle(fontSize: 15)),
                              ))
                        ],
                      ))
                    ],
                  )
                // default to spinner
                : const Center(child: CircularProgressIndicator());
          }),
    );
  }
}

class _WeatherHumidity extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Weather>(
        future: futureWeather,
        builder: (context, snapshot) {
          return snapshot.hasData
              ? Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Column(
                    children: [
                      Row(children: [
                        const Icon(Icons.percent),
                        const SizedBox(width: 10),
                        Text('${snapshot.data!.humidity}%')
                      ]),
                      Row(children: [
                        const Icon(Icons.place),
                        const SizedBox(width: 10),
                        Text(snapshot.data!.location)
                      ])
                    ],
                  ),
                )
              // default to spinner
              : const Center(child: CircularProgressIndicator());
        });
  }
}

class _LastUpdated extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Weather>(
        future: futureWeather,
        builder: (context, snapshot) {
          return snapshot.hasData
              ? Padding(
                  padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
                  child: Text(snapshot.data!.lastUpdated))
              //default to spinner
              : const Center(child: CircularProgressIndicator());
        });
  }
}

class _HourlyPrediction extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(color: Colors.white),
          bottom: BorderSide(color: Colors.white),
        ),
      ),
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: 24,
          itemBuilder: (context, index) {
            return FutureBuilder<List<HourlyForecast>>(
              future: futureHourly,
              builder: (context, snapshot) {
                return snapshot.hasData
                    ? SizedBox(
                        width: 50,
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: Column(
                              children: [
                                Text(
                                    DateFormat("hh a").format(DateTime.now()
                                        .add(Duration(hours: index))),
                                    style: const TextStyle(fontSize: 9)),
                                Padding(
                                  padding:
                                      const EdgeInsets.only(top: 5, bottom: 5),
                                  child: getIcons(
                                      snapshot.data![index].iconId, 20),
                                ),
                                Text(snapshot.data![index].temperature,
                                    style: const TextStyle(fontSize: 9)),
                              ],
                            ),
                          ),
                        ))
                    : const Center(child: CircularProgressIndicator());
              },
            );
          }),
    );
  }
}

class _FiveDayForecast extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SizedBox(
        height: 100,
        child: ListView.builder(
            scrollDirection: Axis.vertical,
            itemCount: 6,
            itemBuilder: (context, index) {
              if (index == 0) {
                return Padding(
                  padding: const EdgeInsets.only(
                      left: 10, right: 10, top: 20, bottom: 10),
                  child: Row(children: const [
                    Expanded(child: Text('Day')),
                    Spacer(),
                    Expanded(child: Text('Weather')),
                    Spacer(),
                    Expanded(child: Text('Temp')),
                    Spacer(),
                    Expanded(child: Text('Min')),
                    Spacer(),
                    Expanded(child: Text('Max')),
                  ]),
                );
              }
              return FutureBuilder<List<Forecast>>(
                  future: futureForecast,
                  builder: (context, snapshot) {
                    return snapshot.hasData
                        ? SizedBox(
                            height: 50,
                            child: Card(
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(left: 10, right: 10),
                                child: Row(children: [
                                  Text(DateFormat("EEE").format(DateTime.now()
                                      .add(Duration(days: index)))),
                                  const Spacer(),
                                  getIcons(snapshot.data![index].iconId, 20),
                                  const Spacer(),
                                  Text('${snapshot.data![index].temperature}'),
                                  const Spacer(),
                                  Text(
                                      '${snapshot.data![index].minTemperature}'),
                                  const Spacer(),
                                  Text(
                                      '${snapshot.data![index].maxTemperature}'),
                                ]),
                              ),
                            ))
                        : const Center(child: CircularProgressIndicator());
                  });
            }),
      ),
    );
  }
}

Future<Weather> fetchCurrentWeather() async {
  try {
    final response = await http.get(Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?lat=51.509865&lon=-0.118092&units=metric&appid=4dfc56c59d987fa85a9c1602e29e74a5'));

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

// TODO -- refactor into map/dictionary
Icon getIcons(String iconId, double? iconSize) {
  if (iconId.startsWith('01')) {
    return Icon(Icons.sunny, size: iconSize);
  } else if (iconId.startsWith('02')) {
    return Icon(Icons.sunny, size: iconSize);
  } else if (iconId.startsWith('03')) {
    return Icon(Icons.cloud_sharp, size: iconSize);
  } else if (iconId.startsWith('04')) {
    return Icon(Icons.cloud_outlined, size: iconSize);
  } else if (iconId.startsWith('09')) {
    return Icon(Icons.water_drop_outlined, size: iconSize);
  } else if (iconId.startsWith('10')) {
    return Icon(Icons.water_drop_sharp, size: iconSize);
  } else if (iconId.startsWith('11')) {
    return Icon(Icons.thunderstorm, size: iconSize);
  } else if (iconId.startsWith('13')) {
    return Icon(Icons.cloudy_snowing, size: iconSize);
  } else if (iconId.startsWith('50')) {
    return Icon(Icons.foggy, size: iconSize);
  } else {
    return Icon(Icons.sunny, size: iconSize);
  }
}

Future<List<Forecast>> fetchFiveDayForecast() async {
  List<Forecast> forecast = [];

  try {
    final response = await http.get(Uri.parse(
        'https://api.openweathermap.org/data/2.5/forecast?lat=51.509865&lon=-0.118092&units=metric&appid=4dfc56c59d987fa85a9c1602e29e74a5'));

    if (response.statusCode == 200) {
      var decode = jsonDecode(response.body);
      var encode = jsonEncode(decode['list']);
      var decode2 = jsonDecode(encode);
      var list = decode['list'];

      for (int i = 0; i < list.length; i++) {
        forecast.add(Forecast(
            description: list[i]['weather'][0]['main'],
            temperature: list[i]['main']['temp'].toDouble(),
            humidity: list[i]['main']['humidity'],
            minTemperature: list[i]['main']['temp_min'].toDouble(),
            maxTemperature: list[i]['main']['temp_max'].toDouble(),
            iconId: list[i]['weather'][0]['icon']));
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
            iconId: hourlyList[i]['weather'][0]['icon']));
      }
      return hourlyForecast;
    } else {
      throw Exception('Failed to fetch weather data');
    }
  } catch (exception) {
    print('Exception thrown fetching current weather: $exception');

    return [];
  }
}
