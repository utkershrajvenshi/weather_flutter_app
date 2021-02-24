import 'dart:ui';

import 'file:///C:/Users/KRITIKA-PC/AndroidStudioProjects/Clima-Flutter/lib/screens/daily_forecast_screen.dart';
import 'file:///C:/Users/KRITIKA-PC/AndroidStudioProjects/Clima-Flutter/lib/components/throw_image.dart';
import 'file:///C:/Users/KRITIKA-PC/AndroidStudioProjects/Clima-Flutter/lib/components/forecast_box.dart';
import 'package:flutter/material.dart';
import 'package:weather_flutter_app/services/weather.dart';
import 'package:weather_flutter_app/utilities/constants.dart';
import 'package:weather_flutter_app/utilities/master_module.dart';

class HomeScreen extends StatefulWidget {
  final List weatherJSONList;

  HomeScreen({this.weatherJSONList});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Map<String, dynamic> weatherValuesMap, hourlyWeatherMap, dailyWeatherMap;
  String cityName;
  bool _visibility = false;

  @override
  void initState() {
    super.initState();
    updateUI(widget.weatherJSONList);
  }

  @override
  void dispose() {
    Navigator.of(context).pop(null);
    super.dispose();
  }

  void updateUI(var weatherDataJSON) {
    setState(() {
      weatherValuesMap = MasterModule.serveValuesFromJSON(
          weatherDataJSON.elementAt(0), JSONType.weatherAtLocationOrCity);
      hourlyWeatherMap = MasterModule.serveValuesFromJSON(
          weatherDataJSON.elementAt(1), JSONType.weatherHourly);
      dailyWeatherMap = MasterModule.serveValuesFromJSON(
          weatherDataJSON.last, JSONType.weatherDaily);
    });
  }

  @override
  Widget build(BuildContext context) {
    var deviceData = MediaQuery.of(context).size;
    return SafeArea(
      child: Stack(
        children: [
          Scaffold(
            floatingActionButton: FloatingActionButton.extended(
              backgroundColor: weatherValuesMap['d/n']
                  ? kDayColors.first
                  : kNightColors.first,
              focusColor:
                  weatherValuesMap['d/n'] ? kDayColors.last : kNightColors.last,
              icon: Icon(
                Icons.navigate_next_rounded,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => DailyForecast(
                              dailyWeatherValues: dailyWeatherMap,
                            )));
              },
              label: Text('Next 7 Days'),
            ),
            backgroundColor: Colors.white,
            body: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 17.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          spreadRadius: 4.0,
                          color: Colors.grey.shade200,
                          blurRadius: 10.0,
                        )
                      ],
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    child: constructLocationContainer(
                        context,
                        weatherValuesMap['d/n']
                            ? kDayColors.first
                            : kNightColors.first),
                  ),
                  SizedBox(
                    height: deviceData.width * 0.1,
                  ),
                  Container(
                    alignment: Alignment.center,
                    width: deviceData.width * 0.92,
                    height: deviceData.width * 0.92,
                    decoration: ShapeDecoration(
                      shape: CircleBorder(),
                      gradient: LinearGradient(
                        colors:
                            weatherValuesMap['d/n'] ? kDayColors : kNightColors,
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        stops: [0.1, 0.9],
                      ),
                    ),
                    child: Container(
                      width: deviceData.width * 0.5,
                      height: deviceData.width * 0.5,
                      child: FittedBox(
                        child: Stack(
                          children: [
                            ImageFiltered(
                              imageFilter:
                                  ImageFilter.blur(sigmaY: 1.5, sigmaX: -1.5),
                              child: Opacity(
                                opacity: 0.1,
                                child: ClipRect(
                                  clipBehavior: Clip.hardEdge,
                                  child: Image(
                                    color: Colors.black,
                                    image: ThrowImage.weatherIcon(
                                        weatherValuesMap['id'],
                                        weatherValuesMap['d/n']),
                                    alignment: Alignment.center,
                                    fit: BoxFit.scaleDown,
                                  ),
                                ),
                              ),
                            ),
                            Image(
                              image: ThrowImage.weatherIcon(
                                  weatherValuesMap['id'],
                                  weatherValuesMap['d/n']),
                              alignment: Alignment.center,
                              fit: BoxFit.scaleDown,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: deviceData.width * 0.1,
                  ),
                  Text(
                    weatherValuesMap['description'].toString(),
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headline3,
                    // .copyWith(fontSize: 20.0)
                  ),
                  SizedBox(
                    height: deviceData.width * 0.1,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      constructSunriseSunset(
                          context, 'Sunrise :', weatherValuesMap['sunrise']),
                      SizedBox(
                        height: 10.0,
                      ),
                      constructSunriseSunset(
                          context, 'Sunset :', weatherValuesMap['sunset']),
                    ],
                  ),
                  SizedBox(
                    height: deviceData.width * 0.1,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Text(
                          'Hourly Forecast',
                          style: Theme.of(context).textTheme.headline6,
                        ),
                      ),
                      SizedBox(
                        height: deviceData.height * 0.2,
                        child: ListView.builder(
                          itemCount: 24,
                          scrollDirection: Axis.horizontal,
                          padding: EdgeInsets.symmetric(horizontal: 8.0),
                          itemBuilder: (context, index) {
                            List<String> receivedHourList =
                                hourlyWeatherMap['hour'];
                            List<int> receivedIconList = hourlyWeatherMap['id'];
                            List<int> receivedTemperatureList =
                                hourlyWeatherMap['temperature'];

                            return ForecastBox(
                              hour: receivedHourList[index],
                              iconId: receivedIconList[index],
                              temperature: receivedTemperatureList[index],
                              borderColour: weatherValuesMap['d/n']
                                  ? kDayColors.last
                                  : kNightColors.last,
                            );
                          },
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: deviceData.width * 0.15,
                  ),
                ],
              ),
            ),
          ),
          Visibility(
            visible: _visibility,
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 12.0, sigmaY: 12.0),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _visibility = false;
                  });
                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  decoration: BoxDecoration(
                      color: Colors.grey.shade600.withOpacity(0.5)),
                  child: Column(
                    children: [
                      Material(
                        type: MaterialType.transparency,
                        child: TextField(
                          onChanged: (value) {
                            cityName = value;
                          },
                          textAlign: TextAlign.center,
                          autofocus: false,
                          decoration: InputDecoration(
                              hintText: 'search city name',
                              border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.circular(5.0)),
                              prefixIcon:
                                  Icon(Icons.search, color: Colors.black)),
                        ),
                      ),
                      SizedBox(
                        height: deviceData.height * 0.1,
                      ),
                      RaisedButton(
                          color: Colors.white,
                          onPressed: () async {
                            //TODO: implement add location functionality
                            List<dynamic> cityData = await WeatherModel()
                                .getWeatherByCityName(cityName);
                            print('cityData: $cityData');
                            if (cityData.isEmpty) {
                              print(
                                  'Location not found! Please try again with a different keyword');
                              // Scaffold.of(context).showSnackBar(
                              //   SnackBar(
                              //     backgroundColor: Colors.lightBlue.shade100,
                              //     shape: RoundedRectangleBorder(
                              //         borderRadius: BorderRadius.vertical(
                              //             top: Radius.circular(5.0))),
                              //     content: Text(
                              //         'Location not found! Please try again with a different keyword'),
                              //   ),
                              // );
                            } else {
                              updateUI(cityData);
                              setState(() {
                                _visibility = false;
                              });
                            }
                          },
                          child: Text(
                            'Get Weather',
                            style: Theme.of(context)
                                .textTheme
                                .button
                                .copyWith(fontWeight: FontWeight.bold),
                          ))
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget constructLocationContainer(BuildContext context, Color textColor) {
    return Container(
      height: 50.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                _visibility = true;
              });
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${weatherValuesMap['name']}, ${weatherValuesMap['country']}',
                  style: Theme.of(context).textTheme.headline6.copyWith(
                      fontWeight: FontWeight.w900,
                      color: weatherValuesMap['d/n']
                          ? kDayColors.first
                          : kNightColors.first),
                ),
                Text(
                  kWeekDays[weatherValuesMap['weekday'] - 1],
                  style: Theme.of(context).textTheme.subtitle2.copyWith(
                      color: weatherValuesMap['d/n']
                          ? kDayColors.first
                          : kNightColors.first),
                ),
              ],
            ),
          ),
          Expanded(
            child: FittedBox(
              fit: BoxFit.contain,
              alignment: Alignment.centerRight,
              child: Text(
                '${weatherValuesMap['temperature']}°C',
                style: Theme.of(context).textTheme.headline6.copyWith(
                    fontWeight: FontWeight.bold,
                    color: weatherValuesMap['d/n']
                        ? kDayColors.first
                        : kNightColors.first),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Row constructSunriseSunset(BuildContext context, String label, String time) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Text(label, style: Theme.of(context).textTheme.headline6),
        Text(time, style: Theme.of(context).textTheme.headline6),
      ],
    );
  }
}
