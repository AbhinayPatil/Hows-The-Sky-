import 'package:flutter/cupertino.dart';

class CurrentLocationProvider with ChangeNotifier {
  String? _currentSubLocality;
  String? _currentLocality;
  String? _currentPinCode;
  String? _lat;
  String? _lon;

  String? get currentSubLocality => _currentSubLocality;
  String? get currentLocality => _currentLocality;
  String? get currentPinCode => _currentPinCode;
  String? get lat => _lat;
  String? get lon => _lon;

  void getLocation(
    String subLoc,
    String loc,
    String pin,
    String lat,
    String lon,
  ) {
    _currentLocality = loc;
    _currentPinCode = pin;
    _currentSubLocality = subLoc;
    _lat = lat;
    _lon = lon;
    notifyListeners();
  }
}
