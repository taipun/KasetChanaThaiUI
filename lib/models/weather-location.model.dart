class WeatherLocation {
  String city;
  String region;
  int woeid;
  String country;
  double lat;
  double long;
  String timezoneId;

  WeatherLocation(
      {this.city,
      this.region,
      this.woeid,
      this.country,
      this.lat,
      this.long,
      this.timezoneId});

  factory WeatherLocation.fromJson(Map<String, dynamic> parsedJson) {
    try {
      return WeatherLocation(
          city: parsedJson['city'] ?? '',
          region: parsedJson['region'] ?? '',
          woeid: parsedJson['woeid'] ?? 0,
          country: parsedJson['country'] ?? '',
          lat: double.tryParse(parsedJson['lat'].toString()) != null
              ? double.parse(parsedJson['lat'].toString())
              : 0.0,
          long: double.tryParse(parsedJson['long'].toString()) != null
              ? double.parse(parsedJson['long'].toString())
              : 0.0,
          timezoneId: parsedJson['timezone_id'] ?? '');
    } catch (ex) {
      print('WeatherLocationModel WeatherLocation ====> $ex');
      throw ('factory WeatherLocation.fromJson ====> $ex');
    }
  }

  Map<String, dynamic> toJson() => {
        'city': city ?? '',
        'region': region ?? '',
        'woeid': woeid ?? 0,
        'country': country ?? '',
        'lat': lat ?? 0.0,
        'long': long ?? 0.0,
        'timezone_id': timezoneId ?? '',
      };
}
