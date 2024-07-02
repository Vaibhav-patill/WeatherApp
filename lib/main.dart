import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weather_app/weatherservice.dart';
import 'weatherscreen.dart';

void main() {
  runApp(WeatherApp());
}

class WeatherApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Weather App',
      home: WeatherScreen(),
    );
  }
}

