import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weatherapp/providers/forecast_weather_provider.dart';

import '../providers/current_location_provider.dart';
import '../utils/forecast_day_listtile.dart';

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
      backgroundColor: const Color.fromARGB(255, 17, 22, 50),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color.fromARGB(255, 17, 22, 50),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_outlined,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          "Forecast",
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
          ),
        ),
      ),
      body: Consumer<ForecastWeatherProvider>(
        builder: (context, value, child) {
          if (value.isLoading) {
            return const Center(child: CircularProgressIndicator());
          } else {
            double _height = MediaQuery.of(context).size.height;
            return Wrap(
              children: [
                SizedBox(
                  height: _height * .1,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Row(
                      children: const [
                        Icon(
                          Icons.calendar_month,
                          color: Colors.white70,
                        ),
                        Text(
                          "\t\t7 days forecast",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: _height * .72,
                  child: ListView.builder(
                    itemCount: value.forecastData.length,
                    itemBuilder: (context, index) => ForecastDayListTile(
                      index: index,
                      forecastDay: value.forecastData[index],
                    ),
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
