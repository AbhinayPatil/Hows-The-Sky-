import 'package:flutter/material.dart';

class CurrentWeatherModel {
  String imageUrl = "";
  String currentTemp = "";
  String description = "";
  String windSpeed = "";
  String feelsLike = "";
  String humidity = "";
  String windDirection = "";
  String windDegree = "";
  Map<String, double> aqi = {}; //store info about aqi
  String aqiStandard =
      ""; //excellent,fair,poor,unhealthy,very unhealthy,hazardous
  Color aqiColor = Colors.white;

  CurrentWeatherModel({
    required this.aqi,
    required this.aqiColor,
    required this.aqiStandard,
    required this.currentTemp,
    required this.description,
    required this.feelsLike,
    required this.humidity,
    required this.imageUrl,
    required this.windDegree,
    required this.windDirection,
    required this.windSpeed,
  });
}
