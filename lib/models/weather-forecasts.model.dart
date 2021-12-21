class WeatherForecasts {
  String day;
  int date;
  int low;
  int high;
  String text;
  int code;

  WeatherForecasts(
      {this.day, this.date, this.low, this.high, this.text, this.code});

  factory WeatherForecasts.fromJson(Map<String, dynamic> parsedJson) {
    try {
      return WeatherForecasts(
          day: parsedJson['day'] ?? '',
          date: parsedJson['date'] ?? 0,
          low: parsedJson['low'] ?? 0,
          high: parsedJson['high'] ?? 0,
          text: parsedJson['text'] ?? '',
          code: parsedJson['code'] ?? 0);
    } catch (ex) {
      print('WeatherForecastsModel WeatherForecasts ====> $ex');
      throw ('factory WeatherForecasts.fromJson ====> $ex');
    }
  }

  Map<String, dynamic> toJson() => {
        'day': day ?? '',
        'date': date ?? 0,
        'low': low ?? 0,
        'high': high ?? 0,
        'text': text ?? '',
        'code': code ?? 0,
      };
}
