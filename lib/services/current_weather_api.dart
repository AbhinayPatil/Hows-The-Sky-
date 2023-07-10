import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:weatherapp/models/current_weather_model.dart';

class CurrentWeatherApi {
  static String baseUrl = 'https://api.weatherapi.com/v1';
  static String apiKey = '';
  late CurrentWeatherModel currentWeather;

  String stringResponse = "";
  Map mapResponse = {};
  Map<String, double> aqi = {}; //store info about aqi
  String aqiStandard =
      ""; //excellent,fair,poor,unhealthy,very unhealthy,hazardous
  Color aqiColor = Colors.white; //bg color to show aqi

  Future<CurrentWeatherModel> apiCall(String lat, String lon) async {
    String url = "$baseUrl/current.json?key=$apiKey&q=$lat,$lon&aqi=yes";
    http.Response response;
    response = await http.get(Uri.parse(url));
    if (response != null && response.statusCode == 200) {
      mapResponse = jsonDecode(response.body);
      aqi['co'] = double.parse(
        mapResponse['current']['air_quality']['co'].toStringAsFixed(1),
      );
      aqi['no2'] = double.parse(
          mapResponse['current']['air_quality']['no2'].toStringAsFixed(1));
      aqi['o3'] = double.parse(
          mapResponse['current']['air_quality']['o3'].toStringAsFixed(1));
      aqi['so2'] = double.parse(
          mapResponse['current']['air_quality']['so2'].toStringAsFixed(1));
      aqi['pm2_5'] = double.parse(
          mapResponse['current']['air_quality']['pm2_5'].toStringAsFixed(1));
      aqi['pm10'] = double.parse(
          mapResponse['current']['air_quality']['pm10'].toStringAsFixed(1));
      aqi['us-epa-index'] = double.parse(mapResponse['current']['air_quality']
              ['us-epa-index']
          .toStringAsFixed(1));
      _setAqiStandards();
      currentWeather = CurrentWeatherModel(
        aqi: aqi,
        aqiColor: aqiColor,
        aqiStandard: aqiStandard,
        currentTemp: mapResponse['current']['temp_c'].toString(),
        description: mapResponse['current']['condition']['text'],
        feelsLike: '${mapResponse['current']['feelslike_c'].toString()}°C',
        humidity: '${mapResponse['current']['humidity'].toString()}%',
        imageUrl: 'https:${mapResponse['current']['condition']['icon']}',
        windDegree: '${mapResponse['current']['wind_degree'].toString()}°',
        windDirection: mapResponse['current']['wind_dir'],
        windSpeed: '${mapResponse['current']['wind_kph'].toString()}km/h',
      );
      return currentWeather;
    }
    currentWeather = CurrentWeatherModel(
      aqi: aqi,
      aqiColor: aqiColor,
      aqiStandard: aqiStandard,
      currentTemp: "",
      description: "",
      feelsLike: '',
      humidity: '',
      imageUrl: '',
      windDegree: '',
      windDirection: "",
      windSpeed: '',
    );
    return currentWeather;
  }

  void _setAqiStandards() {
    double? temp = aqi['us-epa-index'];
    if (temp == 1) {
      aqiStandard = "Excellent";
      aqiColor = Colors.blue.shade300.withOpacity(.8);
    } else if (temp == 2) {
      aqiStandard = "Fair";
      aqiColor = Colors.green.shade300.withOpacity(.8);
    } else if (temp == 3) {
      aqiStandard = "Poor";
      aqiColor = Colors.amber.shade300.withOpacity(.7);
    } else if (temp == 4) {
      aqiStandard = "Unhealthy";
      aqiColor = Colors.red.shade300;
    } else if (temp == 5) {
      aqiStandard = "Very Unhealthy";
      aqiColor = Colors.purple.shade300.withOpacity(.7);
    } else if (temp == 6) {
      aqiStandard = "Hazardous";
      aqiColor = Colors.indigo.shade300;
    } else {
      aqiStandard = "--";
      aqiColor = Colors.blueGrey.withOpacity(.3);
    }
  }
}
