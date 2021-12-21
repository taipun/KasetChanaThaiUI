import 'weather-current-observation.model.dart';
import 'weather-forecasts.model.dart';
import 'weather-location.model.dart';

class Weather {
  WeatherLocation location;
  WeatherCurrentObservation currentObservation;
  List<WeatherForecasts> forecasts;

  Weather({this.location, this.currentObservation, this.forecasts});

  factory Weather.fromJson(Map<String, dynamic> parsedJson) {
    try {
      var forecastsList = (parsedJson['forecasts'] ?? []) as List;
      return Weather(
          location: parsedJson['location'] != null
              ? WeatherLocation.fromJson(parsedJson['location'])
              : WeatherLocation(),
          currentObservation: parsedJson['current_observation'] != null
              ? WeatherCurrentObservation.fromJson(
                  parsedJson['current_observation'])
              : WeatherCurrentObservation(),
          forecasts: forecastsList.isNotEmpty
              ? forecastsList
                  .map((element) => WeatherForecasts.fromJson(element))
                  .toList()
              : []);
    } catch (ex) {
      print('WeatherModel Weather ====> $ex');
      throw ('factory Weather.fromJson ====> $ex');
    }
  }

  Map<String, dynamic> toJson() => {
        'location': location?.toJson() ?? {},
        'current_observation': currentObservation?.toJson() ?? {},
        // 'forecasts': forecasts.toString(),
      };
}
