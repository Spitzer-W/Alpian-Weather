import 'package:alpian_weather/api_service.dart';
import 'package:alpian_weather/objects/Weather.dart';
import 'package:alpian_weather/objects/forecast.dart';
import 'package:alpian_weather/objects/hourlyforecast.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();

    fetchLatestWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Alpian Weather'), actions: [
        IconButton(
          icon: const Icon(Icons.refresh),
          onPressed: () {
            fetchLatestWeather();
            setState(() {});
          },
        ),
        // IconButton(
        //     icon: const Icon(Icons.web),
        //     onPressed: () async {
        //       WebViewController controller = WebViewController();
        //       controller.loadUrl("https://google.co.uk/");
        //       Navigator.push(
        //         context,
        //         MaterialPageRoute(
        //             builder: (context) => WebView(
        //                   onWebViewCreated: (WebViewController controller) {},
        //                 )),
        //       );
        //     })
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

void fetchLatestWeather() {
  ApiService().fetchCurrentWeather();
  ApiService().fetchFiveDayForecast();
  ApiService().fetchHourlyForecast();
}

class _CurrentDate extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Center(
          child: Text(DateFormat("EEEEE MMM yyyy").format(DateTime.now()))),
    );
  }
}

class _WeatherIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: FutureBuilder<Weather>(
          future: ApiService().futureWeather,
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
          future: ApiService().futureWeather,
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
                          TextSpan(
                              text: '${snapshot.data!.temperature.toInt()}'),
                          const WidgetSpan(
                              alignment: PlaceholderAlignment.top,
                              child: Padding(
                                padding: EdgeInsets.only(top: 10),
                                child:
                                    Text('c', style: TextStyle(fontSize: 15)),
                              ))
                        ],
                      )),
                      Text('min: ${snapshot.data!.minTemperature.toInt()}'),
                      Text('max: ${snapshot.data!.maxTemperature.toInt()}'),
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
        future: ApiService().futureWeather,
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
        future: ApiService().futureWeather,
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
              future: ApiService().futureHourly,
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
                                    DateFormat("h a")
                                        .format(snapshot.data![index].time),
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

List<DataColumn> _createColumns() {
  return [
    const DataColumn(
        label: Text(
      'Day',
      style: TextStyle(fontSize: 10),
    )),
    const DataColumn(
        label: Center(
      child: Text(
        'Weather',
        style: TextStyle(fontSize: 10),
      ),
    )),
    const DataColumn(
        label: Center(
      child: Text(
        'Temp',
        style: TextStyle(fontSize: 10),
      ),
    )),
    const DataColumn(
        label: Text(
      'Min',
      style: TextStyle(fontSize: 10),
    )),
    const DataColumn(
        label: Text(
      'Max',
      style: TextStyle(fontSize: 10),
    )),
  ];
}

class _FiveDayForecast extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SizedBox(
        height: 100,
        child: FutureBuilder<List<Forecast>>(
          future: ApiService().futureForecast,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return SingleChildScrollView(
                  child: DataTable(
                columnSpacing: 30,
                columns: _createColumns(),
                rows: snapshot.data!
                    .map(
                      ((element) => DataRow(
                            cells: <DataCell>[
                              DataCell(SizedBox(
                                width: 70,
                                child: Text(
                                    DateFormat("EEE hh:mm a")
                                        .format(element.date),
                                    style: const TextStyle(fontSize: 10)),
                              )), //Extracting from Map element the value
                              DataCell(
                                  Center(child: getIcons(element.iconId, 20))),
                              DataCell(Center(
                                child: Text(element.temperature,
                                    style: const TextStyle(fontSize: 10)),
                              )),
                              DataCell(Center(
                                child: Text(element.minTemperature,
                                    style: const TextStyle(fontSize: 10)),
                              )),
                              DataCell(Center(
                                child: Text(element.maxTemperature,
                                    style: const TextStyle(fontSize: 10)),
                              )),
                            ],
                          )),
                    )
                    .toList(),
              ));
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}

final Map<String, IconData> iconDictionary = {
  '01': Icons.sunny,
  '02': Icons.sunny,
  '03': Icons.cloud_sharp,
  '04': Icons.cloud_outlined,
  '09': Icons.water_drop_outlined,
  '10': Icons.water_drop_sharp,
  '11': Icons.thunderstorm,
  '13': Icons.cloudy_snowing,
  '50': Icons.foggy,
};

Icon getIcons(String iconId, double? iconSize) {
  var mappedIcon = iconDictionary.entries.where((x) => x.key == iconId);
  return mappedIcon.isNotEmpty
      ? Icon(mappedIcon.first.value, size: iconSize)
      : Icon(Icons.sunny, size: iconSize);
}
