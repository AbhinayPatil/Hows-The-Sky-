import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:weatherapp/providers/current_location_provider.dart';
import 'package:weatherapp/providers/current_weather_provider.dart';
import 'package:weatherapp/screens/aqi_screen.dart';
import 'package:weatherapp/utils/aqi_graph.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key,});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isLoading = true;
  String? _currentSubLocality;
  String? _currentLocality;
  String? _currentPinCode;
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
    Provider.of<CurrentWeatherProvider>(context, listen: false).updateData(
      _lat!,
      _lon!,
    );
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 17, 22, 50),
      body: Consumer<CurrentWeatherProvider>(
        builder: (context, value, child) {
          if (value.isLoading) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [CircularProgressIndicator()],
              ),
            );
          } else {
            return SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    //upper box with important details
                    Container(
                      decoration: const BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black,
                            blurStyle: BlurStyle.outer,
                            blurRadius: 10,
                          ),
                        ],
                        color: Color.fromARGB(255, 30, 37, 78),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 32.0),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 16,
                                horizontal: 16,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  //bell icon
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.blueGrey.withOpacity(
                                        .3,
                                      ),
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(
                                          20,
                                        ),
                                      ),
                                    ),
                                    child: IconButton(
                                      icon: Icon(
                                        Icons.notifications,
                                        color: double.tryParse(value
                                                    .currentWeather
                                                    .currentTemp) ==
                                                null
                                            ? Colors.white
                                            : double.parse(value.currentWeather
                                                        .currentTemp) <=
                                                    24
                                                ? Colors.blue
                                                : Colors.redAccent.shade100,
                                        size: 18,
                                      ),
                                      onPressed: () {},
                                    ),
                                  ),

                                  //date time and place
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        DateFormat('MMMEd')
                                            .format(DateTime.now()),
                                        style: const TextStyle(
                                          color: Colors.white60,
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            "$_currentSubLocality, ",
                                            style: const TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                          Text(
                                            _currentLocality.toString(),
                                            style: const TextStyle(
                                              color: Colors.white60,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.blueGrey.withOpacity(.3),
                                      shape: BoxShape.circle,
                                    ),
                                    child: value.currentWeather.imageUrl == ""
                                        ? const CircularProgressIndicator()
                                        : Padding(
                                            padding: const EdgeInsets.all(16.0),
                                            child: Image.network(
                                              value.currentWeather.imageUrl,
                                              width: 64,
                                              height: 64,
                                            ),
                                          ),
                                  ),
                                  const SizedBox(
                                    width: 16,
                                  ),
                                  Column(
                                    children: [
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            value.currentWeather.currentTemp ==
                                                    ""
                                                ? '--'
                                                : value
                                                    .currentWeather.currentTemp,
                                            style: TextStyle(
                                              fontSize: 54,
                                              color: double.tryParse(value
                                                          .currentWeather
                                                          .currentTemp) ==
                                                      null
                                                  ? Colors.white
                                                  : double.parse(value
                                                              .currentWeather
                                                              .currentTemp) <=
                                                          24
                                                      ? Colors.blue
                                                      : Colors.redAccent,
                                            ),
                                          ),
                                          Text(
                                            '°C',
                                            style: TextStyle(
                                              fontSize: 32,
                                              color: double.tryParse(value
                                                          .currentWeather
                                                          .currentTemp) ==
                                                      null
                                                  ? Colors.white
                                                  : double.parse(value
                                                              .currentWeather
                                                              .currentTemp) <=
                                                          24
                                                      ? Colors.blue
                                                      : Colors.redAccent,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        width: 200,
                                        child: Text(
                                          value.currentWeather.description,
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 24,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                top: 16.0,
                                left: 16,
                                right: 16,
                              ),
                              child: Container(
                                height: 70,
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                  color: Colors.blueGrey.withOpacity(.3),
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(
                                      40,
                                    ),
                                  ),
                                ),
                                child: Center(
                                  child: IntrinsicHeight(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Column(
                                          children: [
                                            const Text(
                                              "Wind",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16,
                                              ),
                                            ),
                                            Text(
                                              value.currentWeather.windSpeed ==
                                                      ""
                                                  ? "--"
                                                  : value
                                                      .currentWeather.windSpeed,
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const VerticalDivider(
                                          color: Colors.black,
                                          thickness: 2,
                                        ),
                                        Column(
                                          children: [
                                            const Text(
                                              "Feels Like",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16,
                                              ),
                                            ),
                                            Text(
                                              value.currentWeather.feelsLike ==
                                                      ""
                                                  ? "--"
                                                  : value
                                                      .currentWeather.feelsLike,
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const VerticalDivider(
                                          color: Colors.black,
                                          thickness: 2,
                                        ),
                                        Column(
                                          children: [
                                            const Text(
                                              "Humidity",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16,
                                              ),
                                            ),
                                            Text(
                                              value.currentWeather.humidity ==
                                                      ""
                                                  ? "--"
                                                  : value
                                                      .currentWeather.humidity,
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => AqiScreen(),
                                        ));
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: value.currentWeather.aqiColor,
                                      borderRadius: const BorderRadius.only(
                                        bottomLeft: Radius.circular(
                                          20,
                                        ),
                                        bottomRight: Radius.circular(
                                          20,
                                        ),
                                      ),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                        left: 16.0,
                                        right: 16,
                                        bottom: 8,
                                        top: 8,
                                      ),
                                      child: Text(
                                        'AQI - ${(value.currentWeather.aqi['us-epa-index'])?.toInt()} (${value.currentWeather.aqiStandard})',
                                        style: const TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    value.currentWeather.aqi.isEmpty
                        ? Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16.0,
                              vertical: 16,
                            ),
                            child: Column(
                              children: const [
                                Text(
                                  "Please Check your internet connection\n&Turn on Location access",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                  ),
                                ),
                                Text(
                                  "(pull to refresh)",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white60,
                                    fontSize: 18,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : AqiGraph(
                            co: value.currentWeather.aqi['co'],
                            epaIndex: value.currentWeather.aqi['us-epa-index'],
                            no2: value.currentWeather.aqi['no2'],
                            o3: value.currentWeather.aqi['o3'],
                            pm10: value.currentWeather.aqi['pm10'],
                            pm2_5: value.currentWeather.aqi['pm2_5'],
                            so2: value.currentWeather.aqi['so2'],
                          ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
