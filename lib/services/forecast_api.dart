import 'dart:convert';

import 'package:weatherapp/models/forecast_day_weather_model.dart';
import 'package:http/http.dart' as http;

class ForecastApi {
  static String baseUrl = 'https://api.weatherapi.com/v1';
  static String apiKey = '';

  String stringResponse = "";
  Map mapResponse = {};
  List<ForecastDayWeatherModel> apiData = [];

  Future<List<ForecastDayWeatherModel>> forecastApiCall(
      String lat, String lon) async {
    String url =
        "$baseUrl/forecast.json?key=$apiKey&q=$lat,$lon&days=8&aqi=no&alerts=no";
    http.Response response;
    response = await http.get(Uri.parse(url));

    if (response.statusCode == 200 || response.statusCode == null) {
      mapResponse = jsonDecode(response.body);
      for (var i = 1; i < 8; i++) {
        ForecastDayWeatherModel forecastDayWeather = ForecastDayWeatherModel(
          date: mapResponse['forecast']['forecastday'][i]['date'],
          maxTemp:
              "${mapResponse['forecast']['forecastday'][i]['day']['maxtemp_c']}°C",
          minTemp:
              "${mapResponse['forecast']['forecastday'][i]['day']['mintemp_c']}°C",
          description: mapResponse['forecast']['forecastday'][i]['day']['condition']
              ['text'],
          humidity:
              "${mapResponse['forecast']['forecastday'][i]['day']['avghumidity']}%",
          imageUrl:
              'https:${mapResponse['forecast']['forecastday'][i]['day']['condition']['icon']}',
          precipitation:
              "${mapResponse['forecast']['forecastday'][i]['day']['totalprecip_mm']}",
          snowfall:
              "${mapResponse['forecast']['forecastday'][i]['day']['totalsnow_cm']}",
          sunrise: mapResponse['forecast']['forecastday'][i]['astro']
              ['sunrise'],
          sunset: mapResponse['forecast']['forecastday'][i]['astro']['sunset'],
          windSpeed:
              "${mapResponse['forecast']['forecastday'][i]['day']['maxwind_kph']}km/h",
        );

        apiData.add(forecastDayWeather);
      }
      return apiData;
    }
   
    return apiData;
  }
}
