class RainMonthly {
  String rmStationNameThai;
  String rmStationNameEnglish;
  String rmYear;
  MonthlyRainfall rmMonthlyRainfall;
  MonthlyRainyDay rmMonthlyRainyDay;

  RainMonthly(
      {this.rmStationNameThai,
      this.rmStationNameEnglish,
      this.rmYear,
      this.rmMonthlyRainfall,
      this.rmMonthlyRainyDay});

  factory RainMonthly.fromJson(Map<String, dynamic> parsedJson) {
    try {
      return RainMonthly(
          rmStationNameThai: parsedJson['StationNameThai'],
          rmStationNameEnglish: parsedJson['StationNameEnglish'],
          rmYear: parsedJson['Year'],
          rmMonthlyRainfall:
              MonthlyRainfall.fromJson(parsedJson['MonthlyRainfall']),
          rmMonthlyRainyDay:
              MonthlyRainyDay.fromJson(parsedJson['MonthlyRainyDay']));
    } catch (ex) {
      print('RainMonthlyModel RainMonthly ====> $ex');
      throw ('factory RainMonthly.fromJson ====> $ex');
    }
  }

  Map<String, dynamic> toJson() => {
        'StationNameThai': rmStationNameThai,
        'StationNameEnglish': rmStationNameEnglish,
        'Year': rmYear,
        'MonthlyRainfall': rmMonthlyRainfall.toJson(),
        'MonthlyRainyDay': rmMonthlyRainyDay.toJson()
      };
}

class MonthlyRainfall {
  String rmRainfallJAN;
  String rmRainfallFEB;
  String rmRainfallMAR;
  String rmRainfallAPR;
  String rmRainfallMAY;
  String rmRainfallJUN;
  String rmRainfallJUL;
  String rmRainfallAUG;
  String rmRainfallSEP;
  String rmRainfallOCT;
  String rmRainfallNOV;
  String rmRainfallDEC;
  String rmRainfallTOTAL;

  MonthlyRainfall({
    this.rmRainfallJAN,
    this.rmRainfallFEB,
    this.rmRainfallMAR,
    this.rmRainfallAPR,
    this.rmRainfallMAY,
    this.rmRainfallJUN,
    this.rmRainfallJUL,
    this.rmRainfallAUG,
    this.rmRainfallSEP,
    this.rmRainfallOCT,
    this.rmRainfallNOV,
    this.rmRainfallDEC,
    this.rmRainfallTOTAL,
  });

  factory MonthlyRainfall.fromJson(Map<String, dynamic> parsedJson) {
    try {
      return MonthlyRainfall(
        rmRainfallJAN: parsedJson['RainfallJAN'],
        rmRainfallFEB: parsedJson['RainfallFEB'],
        rmRainfallMAR: parsedJson['RainfallMAR'],
        rmRainfallAPR: parsedJson['RainfallAPR'],
        rmRainfallMAY: parsedJson['RainfallMAY'],
        rmRainfallJUN: parsedJson['RainfallJUN'],
        rmRainfallJUL: parsedJson['RainfallJUL'],
        rmRainfallAUG: parsedJson['RainfallAUG'],
        rmRainfallSEP: parsedJson['RainfallSEP'],
        rmRainfallOCT: parsedJson['RainfallOCT'],
        rmRainfallNOV: parsedJson['RainfallNOV'],
        rmRainfallDEC: parsedJson['RainfallDEC'],
        rmRainfallTOTAL: parsedJson['RainfallTOTAL'],
      );
    } catch (ex) {
      print('MonthlyRainfallModel MonthlyRainfall ====> $ex');
      throw ('factory MonthlyRainfall.fromJson ====> $ex');
    }
  }

  Map<String, dynamic> toJson() => {
        'RainfallJAN': rmRainfallJAN,
        'RainfallFEB': rmRainfallFEB,
        'RainfallMAR': rmRainfallMAR,
        'RainfallAPR': rmRainfallAPR,
        'RainfallMAY': rmRainfallMAY,
        'RainfallJUN': rmRainfallJUN,
        'RainfallJUL': rmRainfallJUL,
        'RainfallAUG': rmRainfallAUG,
        'RainfallSEP': rmRainfallSEP,
        'RainfallOCT': rmRainfallOCT,
        'RainfallNOV': rmRainfallNOV,
        'RainfallDEC': rmRainfallDEC,
        'RainfallTOTAL': rmRainfallTOTAL,
      };
}

class MonthlyRainyDay {
  String rmRainyDayJAN;
  String rmRainyDayFEB;
  String rmRainyDayMAR;
  String rmRainyDayAPR;
  String rmRainyDayMAY;
  String rmRainyDayJUN;
  String rmRainyDayJUL;
  String rmRainyDayAUG;
  String rmRainyDaySEP;
  String rmRainyDayOCT;
  String rmRainyDayNOV;
  String rmRainyDayDEC;
  String rmRainyDayTOTAL;

  MonthlyRainyDay({
    this.rmRainyDayJAN,
    this.rmRainyDayFEB,
    this.rmRainyDayMAR,
    this.rmRainyDayAPR,
    this.rmRainyDayMAY,
    this.rmRainyDayJUN,
    this.rmRainyDayJUL,
    this.rmRainyDayAUG,
    this.rmRainyDaySEP,
    this.rmRainyDayOCT,
    this.rmRainyDayNOV,
    this.rmRainyDayDEC,
    this.rmRainyDayTOTAL,
  });

  factory MonthlyRainyDay.fromJson(Map<String, dynamic> parsedJson) {
    try {
      return MonthlyRainyDay(
        rmRainyDayJAN: parsedJson['RainyDayJAN'],
        rmRainyDayFEB: parsedJson['RainyDayFEB'],
        rmRainyDayMAR: parsedJson['RainyDayMAR'],
        rmRainyDayAPR: parsedJson['RainyDayAPR'],
        rmRainyDayMAY: parsedJson['RainyDayMAY'],
        rmRainyDayJUN: parsedJson['RainyDayJUN'],
        rmRainyDayJUL: parsedJson['RainyDayJUL'],
        rmRainyDayAUG: parsedJson['RainyDayAUG'],
        rmRainyDaySEP: parsedJson['RainyDaySEP'],
        rmRainyDayOCT: parsedJson['RainyDayOCT'],
        rmRainyDayNOV: parsedJson['RainyDayNOV'],
        rmRainyDayDEC: parsedJson['RainyDayDEC'],
        rmRainyDayTOTAL: parsedJson['RainyDayTOTAL'],
      );
    } catch (ex) {
      print('MonthlyRainyDayModel MonthlyRainyDay ====> $ex');
      throw ('factory MonthlyRainyDay.fromJson ====> $ex');
    }
  }

  Map<String, dynamic> toJson() => {
        'RainyDayJAN': rmRainyDayJAN,
        'RainyDayFEB': rmRainyDayFEB,
        'RainyDayMAR': rmRainyDayMAR,
        'RainyDayAPR': rmRainyDayAPR,
        'RainyDayMAY': rmRainyDayMAY,
        'RainyDayJUN': rmRainyDayJUN,
        'RainyDayJUL': rmRainyDayJUL,
        'RainyDayAUG': rmRainyDayAUG,
        'RainyDaySEP': rmRainyDaySEP,
        'RainyDayOCT': rmRainyDayOCT,
        'RainyDayNOV': rmRainyDayNOV,
        'RainyDayDEC': rmRainyDayDEC,
        'RainyDayTOTAL': rmRainyDayTOTAL,
      };
}
