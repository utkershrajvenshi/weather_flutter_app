import 'package:flutter/material.dart';
import 'package:weather_flutter_app/components/day_tile.dart';
import 'package:weather_flutter_app/utilities/constants.dart';

class DailyForecast extends StatelessWidget {
  final Map<String, dynamic> dailyWeatherValues;
  DailyForecast({@required this.dailyWeatherValues});

  @override
  Widget build(BuildContext context) {
    List<int> weekDayList = dailyWeatherValues['weekday'];
    List<int> iconIdList = dailyWeatherValues['icon'];
    List<List<int>> temperatureList = dailyWeatherValues['temperature'];

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.blueGrey.shade100,
        body: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.1,
              ),
              Text(
                'Next 7 days',
                style: Theme.of(context)
                    .textTheme
                    .headline3
                    .copyWith(color: Color(0xFF611A28)),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.1,
              ),
              Expanded(
                child: Container(
                  // width: MediaQuery.of(context).size.width,
                  // height: MediaQuery.of(context).size.height / 2,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: ListView.builder(
                      itemCount: 7,
                      itemExtent: MediaQuery.of(context).size.height * 0.1,
                      itemBuilder: (itemContext, index) {
                        return DayTile(
                          weekDay: kWeekDays[weekDayList[index] - 1],
                          iconId: iconIdList[index],
                          temperature: temperatureList[index],
                        );
                      }),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
