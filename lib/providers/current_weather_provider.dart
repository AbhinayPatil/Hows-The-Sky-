import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weatherapp/models/current_weather_model.dart';
import 'package:weatherapp/services/current_weather_api.dart';

class CurrentWeatherProvider with ChangeNotifier {
  final _service = CurrentWeatherApi();
  bool isLoading = false;
  CurrentWeatherModel _currentWeather = CurrentWeatherModel(
    aqi: {},
    aqiColor: Colors.white,
    aqiStandard: "",
    currentTemp: "",
    description: "",
    feelsLike: "",
    humidity: "",
    imageUrl: "",
    windDegree: "",
    windDirection: "",
    windSpeed: "",
  );
  CurrentWeatherModel get currentWeather => _currentWeather;

  Future<void> updateData(String lat, String lon) async {
    isLoading = true;
    notifyListeners();
    final response = await _service.apiCall(lat, lon);
    _currentWeather = response;
    isLoading = false;
    notifyListeners();
  }
}
