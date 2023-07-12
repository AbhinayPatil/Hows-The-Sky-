import 'package:flutter/material.dart';
import 'package:weatherapp/screens/home_screen.dart';
import 'package:weatherapp/screens/search_forecast_screen.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _currentIndex = 1;
  List<Widget> pageList = [
    const HomeScreen(),
    const SearchForecastScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 60, 77, 176),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_filled),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: "Search/forecast",
          ),
        ],
        backgroundColor: Colors.black38,
        selectedIconTheme: const IconThemeData(size: 32, color: Colors.white),
        unselectedIconTheme: const IconThemeData(
          size: 24,
          color: Colors.white38,
        ),
        unselectedLabelStyle: const TextStyle(
          color: Colors.white38,
        ),
        selectedLabelStyle: const TextStyle(
          color: Colors.white,
        ),
        unselectedItemColor: Colors.white38,
        selectedItemColor: Colors.white,
        unselectedFontSize: 12,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        currentIndex: _currentIndex,
        onTap: (value) {
          setState(() {
            _currentIndex = value;
          });
        },
        type: BottomNavigationBarType.fixed,
      ),
      body: pageList[_currentIndex],
    );
  }
}
