import 'package:flutter/material.dart';
import 'package:weatherapp/utils/bar_widget.dart';

class AqiGraph extends StatelessWidget {
  double? co;
  double? no2;
  double? o3;
  double? so2;
  double? pm2_5;
  double? pm10;
  double? epaIndex;
  AqiGraph(
      {super.key,
      required this.co,
      required this.no2,
      required this.o3,
      required this.epaIndex,
      required this.pm10,
      required this.pm2_5,
      required this.so2});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16.0,
      ),
      child: Container(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  "Air Quality",
                  style: TextStyle(
                    color: Colors.white.withOpacity(.9),
                    fontSize: 24,
                  ),
                ),
                GestureDetector(
                  onTap: () {},
                  child: Text(
                    "More Info...",
                    style: TextStyle(
                      color: Colors.white.withOpacity(
                        .5,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 16,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 400,
              child: GridView(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: MediaQuery.of(context).size.width ~/ 120,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                children: [
                  BarWidget(
                    value: co!,
                    name: "CO",
                  ),
                  BarWidget(
                    value: no2!,
                    name: "NO2",
                  ),
                  BarWidget(
                    value: o3!,
                    name: "O3",
                  ),
                  BarWidget(
                    value: so2!,
                    name: "SO2",
                  ),
                  BarWidget(
                    value: pm2_5!,
                    name: "PM2.5",
                  ),
                  BarWidget(
                    value: pm10!,
                    name: "PM10",
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
