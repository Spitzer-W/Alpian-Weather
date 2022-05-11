import 'dart:convert';

import 'package:alpian_weather/objects/forecast.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

import '../objects/Weather.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

late Future<Weather> futureWeather;
late Future<Forecast> futureForecast;

class _MyAppState extends State<HomeScreen> {  
  @override
  void initState() {
    super.initState();

    futureWeather = fetchWeather();
    futureForecast = fetchForecast();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Alpian Weather'),
        actions: [
          IconButton(
            onPressed: () {
              futureWeather = fetchWeather();
              futureForecast = fetchForecast();
              // Navigator.pushNamed((context), '/setting');
            }, 
            icon: const Icon(Icons.refresh)
            ),
        ],
      ),
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
        // child: Padding(
          // padding: const EdgeInsets.only(
          //   left: 20,
          //   right: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _cloudIcon(),
              _description(),
              _temperature(),
              _humidity(),
              _location(),
              _date(),
              _lastUpdated(),
              _hourlyPrediction(),
              _fiveDayForecast(),
            ],
          ),
        // ),
      ),
    );
  }
}

//4dfc56c59d987fa85a9c1602e29e74a5
Future<Weather> fetchWeather() async {
  try {
    final response = await http.get(Uri.parse('https://api.openweathermap.org/data/2.5/weather?lat=51.509865&lon=-0.118092&units=metric&appid=4dfc56c59d987fa85a9c1602e29e74a5'));
    
    if (response.statusCode == 200){
      return Weather.fromJson(jsonDecode(response.body));
      } 
      else {
        throw Exception('Failed to fetch weather data');
      }
    }
    catch (exception) {
      print('Exception thrown fetching current weather: $exception');
      
      return Weather(
        temperature: 0,
        description: '?',
        humidity: 0,
        location: '?',
        minTemperature: 0,
        maxTemperature: 0,
        lastUpdated: 'Last updated: ${DateFormat("HH:mm").format(DateTime.now())}'
      );
  }
}

Future<Forecast> fetchForecast() async {
  try {
    final response = await http.get(Uri.parse('https://api.openweathermap.org/data/2.5/forecast?lat=51.509865&lon=-0.118092&units=metric&appid=4dfc56c59d987fa85a9c1602e29e74a5'));
  
    if (response.statusCode == 200){
      return Forecast.fromJson(jsonDecode(response.body));
      } 
      else {
        throw Exception('Failed to fetch weather data');
      }
    }
    catch (exception) {
      print('Exception thrown fetching 5 day forecast: $exception');
      
      return const Forecast(
        temperature: 0,
        description: '?',
        humidity: 0,
        minTemperature: 0,
        maxTemperature: 0,
        );
  }
}

_fiveD1ayForecast() {
  return Expanded(
    child: SizedBox(
      height: 100,
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 1,
        
                crossAxisSpacing: 5.0,
                mainAxisSpacing: 5.0,
      ),
        itemCount: 6,
        scrollDirection: Axis.vertical,
        itemBuilder: (context, index) {
          if (index == 0) {
            return Padding(
              padding: const EdgeInsets.only(
                left: 10,
                right: 10,
                top: 20,
                bottom: 10
              ),
              child: Row(
              children: const [
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
          
          return FutureBuilder<Forecast>(
            future: futureForecast,
            builder: (context, currentForecast) {
              return currentForecast.hasData ? 
                SizedBox(
                  height: 50,
                  child: Flexible(
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.only(
                          left: 10,
                          right: 10
                        ),
                      child: Row(
                        children: [
                          Text(DateFormat("EEE").format(DateTime.now().add(Duration(days: index + 1)))),
                          const Spacer(),
                          const Icon(Icons.cloud),
                          const Spacer(),
                          Text('${currentForecast.data!.temperature}'),
                          const Spacer(),
                          Text('${currentForecast.data!.minTemperature}'),
                          const Spacer(),
                          Text('${currentForecast.data!.maxTemperature}'),

                    ]
                    ),
                ),
              )
            )
          ) 
          : const Center(child: CircularProgressIndicator());
          });
        }),
    )
    );
}

_fiveDayForecast() {
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
                left: 10,
                right: 10,
                top: 20,
                bottom: 10
              ),
              child: Row(
              children: const [
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

          return FutureBuilder<Forecast>(
            future: futureForecast,
            builder: (context, currentForecast) {
              return currentForecast.hasData ? 
                SizedBox(
                  height: 50,
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 10,
                        right: 10
                      ),
                    child: Row(
                      children: [
                        Text(DateFormat("EEE").format(DateTime.now().add(Duration(days: index + 1)))),
                        const Spacer(),
                        const Icon(Icons.cloud),
                        const Spacer(),
                        Text('${currentForecast.data!.temperature}'),
                        const Spacer(),
                        Text('${currentForecast.data!.minTemperature}'),
                        const Spacer(),
                        Text('${currentForecast.data!.maxTemperature}'),

                  ]
                  ),
              ),
            )
          ) 
          : const Center(child: CircularProgressIndicator());
          });
        }),
    ),
  );
}

_hourlyPrediction() {
  return Container(
    height: 100,
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
        return SizedBox(
          width: 50,
          child: Card(
            child: Center(
              child: Text(DateFormat("HH:00 a").format(DateTime.now().add(Duration(hours: index + 1))), 
              style: const TextStyle(fontSize: 9)),
              ),
          )
        );
      }),
  );
}


_lastUpdated() {
    return FutureBuilder<Weather>(
      future: futureWeather,
      builder: (context, currentWeather) {
        return currentWeather.hasData ?
            Padding(
              padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
              child: Text(currentWeather.data!.lastUpdated),
            )
    // default to spinner
    : const Center(child: CircularProgressIndicator());
    });
}

_date() {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Text(DateFormat("EEE MMM yyyy").format(DateTime.now()))
    );
}

// create widget for displaying the current location
_location() {
  return FutureBuilder<Weather>(
      future: futureWeather,
      builder: (context, currentWeather) {
        return currentWeather.hasData ?
        Row(children: [
            const Icon(Icons.place),
            const SizedBox(width: 10),
            Text(currentWeather.data!.location)
            ]
          )
    // default to spinner
    : const Center(child: CircularProgressIndicator());
    });
}

// create widget for displaying the current humidity
_humidity() {
  return FutureBuilder<Weather>(
      future: futureWeather,
      builder: (context, currentWeather) {
        return currentWeather.hasData ?
        Row(children: [
            const Icon(Icons.percent),
            const SizedBox(width: 10),
            Text('${currentWeather.data!.humidity}')
            ]
          )
    // default to spinner
    : const Center(child: CircularProgressIndicator());
    });
}

// create widget for displaying the current weather description
_description() {
  return Center(
    child: FutureBuilder<Weather>(
      future: futureWeather,
      builder: (context, currentWeather) {
        return currentWeather.hasData ?
          Text(currentWeather.data!.description)
      // default to spinner
      : const Center(child: CircularProgressIndicator());
      }),
  );
}

// create widget for displaying the current temperature
_temperature() {
  return Center(
    child: FutureBuilder<Weather>(
      future: futureWeather,
      builder: (context, currentWeather) {
        if (currentWeather.hasData){
           return RichText( 
             text: TextSpan(
               style: const TextStyle(
                 fontSize: 70,
                 fontWeight: FontWeight.w100,
                ),
              children: [
                TextSpan(text: '${currentWeather.data!.temperature}'),
                const WidgetSpan(
                  alignment: PlaceholderAlignment.top,
                  child: Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: Text(
                      'c', 
                      style:  TextStyle(fontSize: 15)
                    ),
                  )
                )
              ],
             )
           );
        } else if (currentWeather.hasError) {
          return Text('${currentWeather.error}');
        }
        // default to spinner
        return const CircularProgressIndicator();
      },
    ),
  );
}

// create widget for displaying the current weather icon
_cloudIcon() {
  // return FutureBuilder<Weather>(
  //     future: futureWeather,
  //     builder: (context, currentWeather) {
  //       return currentWeather.hasData ?
  //          Column(
  //             children: [
  //               const Icon(
  //                 Icons.cloud, 
  //                 size: 80
  //                 ),
  //               Text(
  //                 currentWeather.data!.temperature, 
  //                 style: const TextStyle(
  //                 fontSize: 70,
  //                 fontWeight: FontWeight.w100
  //               ),
  //             )],
  //           )
          

  //       // default to spinner
  //       : const CircularProgressIndicator();
  //     },
  //   );




  return const Icon(
            Icons.cloud, 
            size: 80
          );
}