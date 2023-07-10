import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weatherapp/providers/current_location_provider.dart';
import 'package:weatherapp/providers/current_weather_provider.dart';
import 'package:weatherapp/screens/home_screen.dart';
import 'package:weatherapp/screens/splash_screen.dart';
import 'package:weatherapp/utils/bottom_nav_bar.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => CurrentWeatherProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => CurrentLocationProvider(),
        ),
      ],
      child:  MaterialApp(
        home: SplashScreen(),
      ),
    ),
  );
}
