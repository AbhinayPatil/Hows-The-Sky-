import 'package:flutter/material.dart';
import 'package:weatherapp/models/forecast_day_weather_model.dart';
import 'package:weatherapp/services/forecast_api.dart';

class ForecastWeatherProvider with ChangeNotifier {
  final _service = ForecastApi();
  bool isLoading = false;
  bool loadedOnce = false;
  List<ForecastDayWeatherModel> _forecastData = [];
  List get forecastData => _forecastData;

  Future<void> updateData(String lat, String lon) async {
    isLoading = true;
    notifyListeners();
    if (loadedOnce == false) {
      final response = await _service.forecastApiCall(lat, lon);
      _forecastData = response;
      print("ander ka loop------------------------");
      print(_forecastData);
    }
    print("loop ke bahar ka----------------------------");
    print(_forecastData.toString());
    isLoading = false;
    loadedOnce = true;
    notifyListeners();
  }
}
