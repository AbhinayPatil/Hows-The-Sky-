import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:weatherapp/providers/current_location_provider.dart';
import 'package:weatherapp/utils/bottom_nav_bar.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool isLoading = true;
  String? _currentSubLocality;
  String? _currentLocality;
  String? _currentPinCode;
  Position? _currentPosition;
  int flag = 0;

  //work on location permission
  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Location services are disabled. Please enable the services',
          ),
        ),
      );
      _handleLocationPermission;
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

  //get current position
  Future<void> _getCurrentPosition() async {
    final hasPermission = await _handleLocationPermission();
    if (!hasPermission) return;
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      _currentPosition = position;
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
      _currentSubLocality = place.subLocality;
      _currentLocality = place.locality;
      _currentPinCode = place.postalCode;
    }).catchError((e) {
      debugPrint(e);
    });
    isLoading = false;

    //timer was needed to see that navigation wasnt done before the build of the widget
    Timer(const Duration(seconds: 1), () {
      if (isLoading == false) {
        Provider.of<CurrentLocationProvider>(context, listen: false)
            .getLocation(
          _currentSubLocality.toString(),
          _currentLocality.toString(),
          _currentPinCode.toString(),
          _currentPosition!.latitude.toString(),
          _currentPosition!.longitude.toString(),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const BottomNavBar(),
          ),
        );
      }
    });
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text(
              "Please Check your internet connection\n&Turn on Location access",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
            CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
