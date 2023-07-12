import 'package:flutter/material.dart';

class ForecastDayWeatherModel {
  String date;
  String maxTemp;
  String minTemp;
  String windSpeed;
  String precipitation;
  String snowfall;
  String humidity;
  String description;
  String imageUrl;
  String sunrise;
  String sunset;

  ForecastDayWeatherModel({
    required this.date,
    required this.maxTemp,
    required this.minTemp,
    required this.description,
    required this.humidity,
    required this.imageUrl,
    required this.precipitation,
    required this.snowfall,
    required this.sunrise,
    required this.sunset,
    required this.windSpeed,
  });
}
