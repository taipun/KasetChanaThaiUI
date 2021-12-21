import 'package:flutter/material.dart';

class AppConstants {
  static const double buttonHeight = 70;
  static const double elevation = 10;
  static BorderRadius borderRadius() {
    return BorderRadius.circular(50.0);
  }

  static RoundedRectangleBorder borderCard() {
    return RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0));
  }

  static Radius borderCardRadius() {
    return Radius.circular(15.0);
  }

  static String getWeatherImage(String weather) {
    switch (weather) {
      case 'Mostly Cloudy':
        return 'assets/images/weather/partly-cloudy.png';
        break;
      case 'Cloudy':
        return 'assets/images/weather/partly-cloudy.png';
        break;
      case 'Thunderstorms':
        return 'assets/images/weather/thunderstorms.png';
        break;
      case 'Scattered Thunderstorms':
        return 'assets/images/weather/thunderstorms.png';
        break;
      case 'Partly Cloudy':
        return 'assets/images/weather/partly-cloudy.png';
        break;
      case 'Mostly Sunny':
        return 'assets/images/weather/sunny.png';
        break;
      case 'Sunny':
        return 'assets/images/weather/sunny.png';
        break;
      default:
        return 'assets/images/weather/partly-cloudy.png';
        break;
    }
  }
}
