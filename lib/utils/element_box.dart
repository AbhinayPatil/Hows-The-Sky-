import 'package:flutter/material.dart';

class ElementBox extends StatelessWidget {
  double value;
  String name;
  ElementBox({super.key, required this.value, required this.name});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color.fromARGB(255, 46, 54, 100),
            Color.fromARGB(255, 31, 39, 82),
            Color.fromARGB(255, 17, 22, 50),
          ],
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(
            30,
          ),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            value.toString(),
            style: TextStyle(
              color: Colors.white.withOpacity(
                .8,
              ),
              fontSize: 24,
            ),
          ),
          Text(
            'µg/m³',
            style: TextStyle(
              color: Colors.white.withOpacity(
                .8,
              ),
              fontSize: 12,
            ),
          ),
          const SizedBox(
            width: 100,
            child: Divider(
              color: Colors.black,
              thickness: 2,
            ),
          ),
          Text(
            name,
            style: TextStyle(
              color: Colors.white.withOpacity(
                .8,
              ),
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }
}
