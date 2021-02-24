import 'package:flutter/material.dart';

class ThrowImage {
  static AssetImage weatherIcon(int weatherId, bool isDay) {
    AssetImage assetImage;
    if (weatherId < 210) {
      assetImage = AssetImage('images/2x/Rain with thunder.png');
    } else if (weatherId < 300) {
      assetImage = AssetImage('images/2x/Thunderstorm.png');
    } else if (weatherId < 600) {
      assetImage = AssetImage('images/2x/Rain.png');
    } else if (weatherId < 700) {
      assetImage = AssetImage('images/2x/Cold or snow.png');
    } else if (weatherId < 801) {
      assetImage = isDay
          ? AssetImage('images/2x/Sunny.png')
          : AssetImage('images/2x/Clear Night.png');
    } else if (weatherId < 805) {
      assetImage = isDay
          ? AssetImage('images/2x/Cloudy Day.png')
          : AssetImage('images/2x/Cloudy Night.png');
    }
    return assetImage;
  }
}
