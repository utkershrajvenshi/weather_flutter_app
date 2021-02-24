import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:weather_flutter_app/services/weather.dart';
import 'home_screen.dart';

class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    redirectScreen();
  }

  void redirectScreen() async {
    WeatherModel weatherModel = WeatherModel();
    List<dynamic> weatherData = await weatherModel.getWeatherAtLocation();
    var result = await Navigator.push(_scaffoldKey.currentContext,
        MaterialPageRoute(builder: (context) {
      return HomeScreen(weatherJSONList: weatherData);
    }));
    if (result == null) {
      dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Center(
        child: SpinKitRipple(
          color: Colors.deepPurple,
          size: 240.0,
          borderWidth: 30.0,
        ),
      ),
    );
  }
}
