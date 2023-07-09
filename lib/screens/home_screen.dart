import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:weatherapp/screens/aqi_screen.dart';
import 'package:weatherapp/utils/aqi_graph.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static String baseUrl = 'https://api.weatherapi.com/v1';
  static String apiKey = '';
  String stringResponse = "";
  Map mapResponse = {};
  String imageUrl = "";
  String currentTemp = "";
  String description = "";
  String windSpeed = "";
  String feelsLike = "";
  String humidity = "";
  String windDirection = "";
  String windDegree = "";
  Map<String, double> aqi = {};
  String aqiStandard = "";
  Color aqiColor = Colors.white;

  //work on location permission
  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // ScaffoldMessenger.of(context).showSnackBar(
      //   const SnackBar(
      //     content: Text(
      //       'Location services are disabled. Please enable the services',
      //     ),
      //   ),
      // );
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Location permissions are denied',
            ),
          ),
        );
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Location permissions are permanently denied, we cannot request permissions.',
          ),
        ),
      );
      return false;
    }
    return true;
  }

  String? _currentSubLocality;
  String? _currentLocality;
  String? _currentPinCode;
  Position? _currentPosition;

  //get current position
  Future<void> _getCurrentPosition() async {
    final hasPermission = await _handleLocationPermission();
    if (!hasPermission) return;
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      setState(() => _currentPosition = position);
      _getAddressFromLatLng(_currentPosition!);
    }).catchError((e) {
      debugPrint(e);
    });
  }

  //get locality and subLocality
  Future<void> _getAddressFromLatLng(Position position) async {
    await placemarkFromCoordinates(
            _currentPosition!.latitude, _currentPosition!.longitude)
        .then((List<Placemark> placemarks) {
      Placemark place = placemarks[0];
      setState(() {
        _currentSubLocality = place.subLocality;
        _currentLocality = place.locality;
        _currentPinCode = place.postalCode;
      });
    }).catchError((e) {
      debugPrint(e);
    });
    apiCall();
  }

  //get data from api
  Future apiCall() async {
    String url =
        "$baseUrl/current.json?key=$apiKey&q=${_currentPosition!.latitude},${_currentPosition!.longitude}&aqi=yes";
    http.Response response;
    response = await http.get(Uri.parse(url));
    if (response != null && response.statusCode == 200) {
      setState(() {
        mapResponse = jsonDecode(response.body);
      });
      setState(() {
        imageUrl = 'https:${mapResponse['current']['condition']['icon']}';
        currentTemp = mapResponse['current']['temp_c'].toString();
        description = mapResponse['current']['condition']['text'];
        humidity = '${mapResponse['current']['humidity'].toString()}%';
        feelsLike = '${mapResponse['current']['feelslike_c'].toString()}°C';
        windSpeed = '${mapResponse['current']['wind_kph'].toString()}km/h';
        windDirection = mapResponse['current']['wind_dir'];
        windDegree = '${mapResponse['current']['wind_degree'].toString()}°';
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
      });
    }
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

  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onLoading() async {
    _getCurrentPosition();
    _refreshController.loadComplete();
  }

  void _onRefresh() async {
    _getCurrentPosition();
    _refreshController.refreshCompleted();
  }

  @override
  void initState() {
    // TODO: implement initState
    _getCurrentPosition();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 17, 22, 50),
      body: SmartRefresher(
        enablePullDown: true,
        controller: _refreshController,
        onRefresh: _onRefresh,
        onLoading: _onLoading,
        child: SafeArea(
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                    color: double.tryParse(currentTemp) == null
                                        ? Colors.white
                                        : double.parse(currentTemp) <= 24
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
                                    DateFormat('MMMEd').format(DateTime.now()),
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
                                child: imageUrl == ""
                                    ? const CircularProgressIndicator()
                                    : Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Image.network(
                                          imageUrl,
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
                                        currentTemp == "" ? '--' : currentTemp,
                                        style: TextStyle(
                                          fontSize: 54,
                                          color: double.tryParse(currentTemp) ==
                                                  null
                                              ? Colors.white
                                              : double.parse(currentTemp) <= 24
                                                  ? Colors.blue
                                                  : Colors.redAccent,
                                        ),
                                      ),
                                      Text(
                                        '°C',
                                        style: TextStyle(
                                          fontSize: 32,
                                          color: double.tryParse(currentTemp) ==
                                                  null
                                              ? Colors.white
                                              : double.parse(currentTemp) <= 24
                                                  ? Colors.blue
                                                  : Colors.redAccent,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    width: 200,
                                    child: Text(
                                      description,
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
                                          windSpeed == "" ? "--" : windSpeed,
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
                                          feelsLike == "" ? "--" : feelsLike,
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
                                          humidity == "" ? "--" : humidity,
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
                                  color: aqiColor,
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
                                    'AQI - ${(aqi['us-epa-index'])?.toInt()} ($aqiStandard)',
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
                aqi.isEmpty
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
                        co: aqi['co'],
                        epaIndex: aqi['us-epa-index'],
                        no2: aqi['no2'],
                        o3: aqi['o3'],
                        pm10: aqi['pm10'],
                        pm2_5: aqi['pm2_5'],
                        so2: aqi['so2'],
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
