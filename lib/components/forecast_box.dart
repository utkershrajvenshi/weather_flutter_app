import 'package:flutter/material.dart';
import 'package:weather_flutter_app/components/throw_image.dart';

class DayTile extends StatelessWidget {
  final String weekDay;
  final int iconId;
  final List<int> temperature;

  DayTile({this.weekDay, this.iconId, this.temperature});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          weekDay,
          style: Theme.of(context)
              .textTheme
              .bodyText2
              .copyWith(fontWeight: FontWeight.w500),
        ),
        SizedBox(
          width: 30.0,
          height: 30.0,
          child: FittedBox(
            child: Image(
              image: ThrowImage.weatherIcon(iconId, true),
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${temperature.first}°',
              style: Theme.of(context)
                  .textTheme
                  .bodyText2
                  .copyWith(fontWeight: FontWeight.bold),
            ),
            SizedBox(
              width: 20.0,
            ),
            Text(
              '${temperature.last}°',
              style: Theme.of(context)
                  .textTheme
                  .bodyText2
                  .copyWith(color: Colors.blueGrey.shade600),
            )
          ],
        )
      ],
    );
  }
}
