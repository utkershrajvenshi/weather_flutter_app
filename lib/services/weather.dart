import 'package:weather_flutter_app/utilities/constants.dart';
import 'location.dart';
import 'networking.dart';

class WeatherModel {
  Location loc = Location();

  Future<dynamic> getWeatherAtLocation() async {
    await loc.getCurrentLocation();

    NetworkHelper networkHelper = NetworkHelper(
        'https://api.openweathermap.org/data/2.5/weather?lat=${loc.latitude}&lon=${loc.longitude}&appid=$apiKey&units=metric');

    return await getAIOWeather(await networkHelper.getData());
  }

  Future<dynamic> getAIOWeather(var weatherJson) async {
    List<dynamic> allInOneWeather = [weatherJson];
    allInOneWeather.add(await getHourlyWeather());
    allInOneWeather.add(await getDailyWeather());

    return allInOneWeather;
  }

  Future<dynamic> getWeatherByCityName(String city) async {
    NetworkHelper helper = NetworkHelper(
        'https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey&units=metric');

    var weatherData = await helper.getData();
    if (weatherData['cod'] == 200) {
      loc.longitude = weatherData['coord']['lon'] as double;
      loc.latitude = weatherData['coord']['lat'] as double;
      return await getAIOWeather(weatherData);
    } else {
      print('You reached cod != 200');
      return [];
    }
  }

  Future<dynamic> getHourlyWeather() async {
    NetworkHelper helper = NetworkHelper(
        'https://api.openweathermap.org/data/2.5/onecall?lat=${loc.latitude}&lon=${loc.longitude}&exclude=current,minutely,daily,alerts&appid=$apiKey&units=metric');
    return await helper.getData();
  }

  Future<dynamic> getDailyWeather() async {
    NetworkHelper helper = NetworkHelper(
        'https://api.openweathermap.org/data/2.5/onecall?lat=${loc.latitude}&lon=${loc.longitude}&exclude=current,minutely,hourly,alerts&appid=$apiKey&units=metric');
    return await helper.getData();
  }
}
