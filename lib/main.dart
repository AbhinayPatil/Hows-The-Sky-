import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weatherapp/providers/current_location_provider.dart';
import 'package:weatherapp/providers/current_weather_provider.dart';
import 'package:weatherapp/providers/forecast_weather_provider.dart';
import 'package:weatherapp/screens/splash_screen.dart';

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
        ChangeNotifierProvider(
          create: (_) => ForecastWeatherProvider(),
        ),
      ],
      child: const MaterialApp(
        home: SplashScreen(),
      ),
    ),
  );
}
