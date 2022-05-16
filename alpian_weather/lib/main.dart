import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screens/homescreen.dart';
import 'screens/settingscreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      title: 'Alpian Weather',
      theme: ThemeData(primarySwatch: Colors.blue, brightness: Brightness.dark),
      initialRoute: '/',
      routes: {
        '/': (_) => const HomeScreen(),
        '/setting': (_) => SettingScreen(),
      },
    );
  }
}
