import 'package:flutter/material.dart';
import 'package:weatherapp/models/forecast_day_weather_model.dart';

class ForecastDayListTile extends StatelessWidget {
  int index;
  ForecastDayWeatherModel forecastDay;
  ForecastDayListTile(
      {super.key, required this.index, required this.forecastDay});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: (index % 2 == 0)
          ? const EdgeInsets.only(
              top: 8,
              right: 32,
            )
          : const EdgeInsets.only(
              top: 8,
              left: 32,
            ),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.blue.shade100,
            borderRadius: (index % 2 == 0)
                ? const BorderRadius.only(
                    topRight: Radius.circular(
                      30,
                    ),
                    bottomRight: Radius.circular(
                      30,
                    ),
                  )
                : const BorderRadius.only(
                    topLeft: Radius.circular(
                      30,
                    ),
                    bottomLeft: Radius.circular(
                      30,
                    ),
                  )),
        child: Wrap(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                right: 16.0,
                top: 8,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    "DATE: ${forecastDay.date}",
                    style: TextStyle(
                      color: Colors.blueGrey.withOpacity(.7),
                    ),
                  ),
                ],
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: Column(
                    children: [
                      Text(
                        "max ~ ${forecastDay.maxTemp} / min ~ ${forecastDay.minTemp}",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: const Color.fromARGB(255, 17, 22, 50)
                              .withOpacity(.7),
                        ),
                      ),
                      Text(
                        forecastDay.description,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 17, 22, 50),
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Container(
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(
                              50,
                            ),
                          ),
                        ),
                        child: const Center(
                          child: Text(
                            "AQI-2 (Medium)",
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Image.network(
                  forecastDay.imageUrl,
                  scale: 1,
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8,
              ),
              child: FittedBox(
                fit: BoxFit.fitWidth,
                child: IntrinsicHeight(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text("Humidity-${forecastDay.humidity}%"),
                      const VerticalDivider(
                        thickness: 2,
                        color: Colors.black45,
                      ),
                      Text("WindSpeed-${forecastDay.windSpeed}"),
                      const VerticalDivider(
                        thickness: 2,
                        color: Colors.black45,
                      ),
                      (double.parse(forecastDay.precipitation) != 0)
                          ? Text(
                              "rain-${forecastDay.precipitation}mm",
                            )
                          : (double.parse(forecastDay.snowfall) != 0)
                              ? Text(
                                  "rain-${forecastDay.snowfall}cm",
                                )
                              : Text(
                                  "rain-${forecastDay.sunrise}",
                                ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
