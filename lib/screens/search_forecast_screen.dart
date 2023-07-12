import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weatherapp/providers/forecast_weather_provider.dart';

import '../providers/current_location_provider.dart';

class SearchForecastScreen extends StatefulWidget {
  const SearchForecastScreen({super.key});

  @override
  State<SearchForecastScreen> createState() => _SearchForecastScreenState();
}

class _SearchForecastScreenState extends State<SearchForecastScreen> {
  String? _currentSubLocality;
  String? _currentLocality;
  String? _lat;
  String? _lon;

  @override
  Widget build(BuildContext context) {
    _currentLocality =
        Provider.of<CurrentLocationProvider>(context, listen: false)
            .currentLocality;
    _currentSubLocality =
        Provider.of<CurrentLocationProvider>(context).currentSubLocality;
    _lat = Provider.of<CurrentLocationProvider>(context).lat;
    _lon = Provider.of<CurrentLocationProvider>(context).lon;
    Provider.of<ForecastWeatherProvider>(context, listen: false).updateData(
      _lat!,
      _lon!,
    );
    return Scaffold(
      body: Consumer<ForecastWeatherProvider>(
        builder: (context, value, child) {
          if (value.isLoading) {
            return Center(child: CircularProgressIndicator());
          } else {
            return Center(
              child: Text(value.forecastData.toString()),
            );
          }
        },
      ),
    );
  }
}
