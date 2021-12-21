class RainWeekly {
  String rwProvinceNameTh;
  String rwProvinceNameEng;
  List<SevenDaysForecast> rwSevenDaysForecast;

  RainWeekly(
      {this.rwProvinceNameTh,
      this.rwProvinceNameEng,
      this.rwSevenDaysForecast});

  factory RainWeekly.fromJson(Map<String, dynamic> parsedJson) {
    try {
      var SevenDaysForecastList =
          (parsedJson['SevenDaysForecast'] ?? []) as List;
      return RainWeekly(
          rwProvinceNameTh: parsedJson['ProvinceNameTh'],
          rwProvinceNameEng: parsedJson['ProvinceNameEng'],
          rwSevenDaysForecast: SevenDaysForecastList.map(
              (element) => SevenDaysForecast.fromJson(element)).toList());
    } catch (ex) {
      print('RainWeeklyModel RainWeekly ====> $ex');
      throw ('factory RainWeekly.fromJson ====> $ex');
    }
  }

  Map<String, dynamic> toJson() => {
        'ProvinceNameTh': rwProvinceNameTh,
        'ProvinceNameEng': rwProvinceNameEng
      };
}

class SevenDaysForecast {
  String rwDate;
  String rwMaxTemperature;
  String rwMinTemperature;
  String rwWindDirection;
  String rwWindSpeed;
  String rwRain;
  String rwProvinceNameEng;
  String rwWeatherDescription;
  String rwWeatherDescriptionEn;
  String rwWaveHeight;
  String rwWaveHeightEn;
  String rwTempartureLevel;
  String rwTempartureLevelEn;

  SevenDaysForecast(
      {this.rwDate,
      this.rwMaxTemperature,
      this.rwMinTemperature,
      this.rwWindDirection,
      this.rwWindSpeed,
      this.rwRain,
      this.rwProvinceNameEng,
      this.rwWeatherDescription,
      this.rwWeatherDescriptionEn,
      this.rwWaveHeight,
      this.rwWaveHeightEn,
      this.rwTempartureLevel,
      this.rwTempartureLevelEn});

  factory SevenDaysForecast.fromJson(Map<String, dynamic> parsedJson) {
    try {
      return SevenDaysForecast(
        rwDate: parsedJson['Date'],
        rwMaxTemperature: parsedJson['MaxTemperature']['Value'].toString(),
        rwMinTemperature: parsedJson['MinTemperature']['Value'].toString(),
        rwWindDirection: parsedJson['WindDirection']['Value'].toString(),
        rwWindSpeed: parsedJson['WindSpeed']['Value'].toString(),
        rwRain: parsedJson['Rain']['Value'].toString(),
        rwProvinceNameEng: parsedJson['ProvinceNameEng'],
        rwWeatherDescription: parsedJson['WeatherDescription'],
        rwWeatherDescriptionEn: parsedJson['WeatherDescriptionEn'],
        rwWaveHeight: parsedJson['WaveHeight'],
        rwWaveHeightEn: parsedJson['WaveHeightEn'],
        rwTempartureLevel: parsedJson['TempartureLevel'],
        rwTempartureLevelEn: parsedJson['TempartureLevelEn'],
      );
    } catch (ex) {
      print('SevenDaysForecastModel SevenDaysForecast ====> $ex');
      throw ('factory SevenDaysForecast.fromJson ====> $ex');
    }
  }

  Map<String, dynamic> toJson() => {
        'Date': rwDate,
        'ProvinceNameEng': rwProvinceNameEng,
        'WeatherDescription': rwWeatherDescription,
        'WeatherDescriptionEn': rwWeatherDescriptionEn,
        'WaveHeight': rwWaveHeight,
        'WaveHeightEn': rwWaveHeightEn,
        'TempartureLevel': rwTempartureLevel,
        'TempartureLevelEn': rwTempartureLevelEn,
      };
}
