import 'package:weather_flutter_app/services/weather.dart';
import 'constants.dart';

class MasterModule {
  var weatherModel = WeatherModel();

  void getJSONForHourlyAndDaily() async {
    var hourlyJSON = await weatherModel.getHourlyWeather();
    // var dailyJSON = await weatherModel.getDailyWeather();
    serveValuesFromJSON(hourlyJSON, JSONType.weatherHourly);
  }

  static List<dynamic> _determineDayOrNightAndSunriseSunset(
      int dateId, int sunrise, int sunset) {
    bool dayOrNight = dateId >= sunrise && dateId <= sunset;
    final sunriseTime =
        DateTime.fromMillisecondsSinceEpoch(sunrise * 1000, isUtc: true);
    final sunsetTime =
        DateTime.fromMillisecondsSinceEpoch(sunset * 1000, isUtc: true);
    int weekDay =
        DateTime.fromMillisecondsSinceEpoch(dateId * 1000, isUtc: true).weekday;

    return [
      dayOrNight,
      '${sunriseTime.hour} : ${sunriseTime.minute}',
      '${sunsetTime.hour} : ${sunsetTime.minute}',
      weekDay,
    ];
  }

  static Map<String, dynamic> serveValuesFromJSON(
      var receivedJSON, JSONType jsonType) {
    if (jsonType == JSONType.weatherHourly) {
      List<String> hourList = [];
      List<int> iconIdList = [], temperatureList = [];

      for (int index = 1; index < 25; ++index) {
        int dateID = int.parse(receivedJSON['hourly'][index]['dt'].toString()) +
            int.parse(receivedJSON['timezone_offset'].toString());
        int hour =
            DateTime.fromMillisecondsSinceEpoch(dateID * 1000, isUtc: true)
                .hour;
        int iconID = receivedJSON['hourly'][index]['weather'][0]['id'] as int;
        double temp =
            double.parse(receivedJSON['hourly'][index]['temp'].toString());
        // double temp = 10.6;

        hourList.add(hour >= 12
            ? '${hour == 12 ? hour : hour - 12}PM'
            : '${hour == 0 ? 12 : hour}AM');
        iconIdList.add(iconID);
        temperatureList.add(temp.round());
      }

      return {
        'hour': hourList,
        'id': iconIdList,
        'temperature': temperatureList,
      };
    } else if (jsonType == JSONType.weatherDaily) {
      List<int> weekDayList = [], iconIdList = [];
      List<List<int>> temperatureList = [];

      for (int index = 1; index <= 7; ++index) {
        int dateID = int.parse(receivedJSON['daily'][index]['dt'].toString()) +
            int.parse(receivedJSON['timezone_offset'].toString());
        int weekDay =
            DateTime.fromMillisecondsSinceEpoch(dateID * 1000, isUtc: true)
                .weekday;
        double tempMin = double.parse(
            receivedJSON['daily'][index]['temp']['min'].toString());
        double tempMax = double.parse(
            receivedJSON['daily'][index]['temp']['max'].toString());
        int iconID = receivedJSON['daily'][index]['weather'][0]['id'] as int;

        weekDayList.add(weekDay);
        iconIdList.add(iconID);
        temperatureList.add([tempMax.round(), tempMin.round()]);
      }

      print('$temperatureList\n\n\n$iconIdList');
      return {
        'weekday': weekDayList,
        'icon': iconIdList,
        'temperature': temperatureList,
      };
    } else {
      List valuesList = _determineDayOrNightAndSunriseSunset(
        int.parse(receivedJSON['dt'].toString()) +
            int.parse(receivedJSON['timezone'].toString()),
        int.parse(receivedJSON['sys']['sunrise'].toString()) +
            int.parse(receivedJSON['timezone'].toString()),
        int.parse(receivedJSON['sys']['sunset'].toString()) +
            int.parse(receivedJSON['timezone'].toString()),
      );

      double temp = double.parse(receivedJSON['main']['temp'].toString());
      // double temp = 10.6;

      return {
        'id': receivedJSON['weather'][0]['id'] as int,
        'description': receivedJSON['weather'][0]['description'].toString(),
        'temperature': temp.round(),
        'd/n': valuesList[0],
        'sunrise': valuesList[1],
        'sunset': valuesList[2],
        'weekday': valuesList[3],
        'country': receivedJSON['sys']['country'].toString(),
        'name': receivedJSON['name'].toString(),
      };
    }
  }
}
