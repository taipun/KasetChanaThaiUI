import 'dart:io';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:kasetchana_flutter/models/rain-monthly.model.dart';
import 'package:kasetchana_flutter/models/rain-weekly.model.dart';
import 'package:kasetchana_flutter/models/region.model.dart';
import 'package:kasetchana_flutter/models/weather.model.dart';
import 'package:kasetchana_flutter/services/auth.service.dart';

import 'package:kasetchana_flutter/utilities/globals.dart';

class WeatherService {
  static const className = 'WeatherService';
  var _baseUrl = '${Globals.API}';

  Future<Weather> getWeather() async {
    var headers = {
      HttpHeaders.authorizationHeader:
          'Bearer ${await AuthService().getToken()}',
      HttpHeaders.contentTypeHeader: 'application/json'
    };
    var response =
        await http.get(Uri.parse('$_baseUrl/weather'), headers: headers);
    if (response.statusCode == 200) {
      return Weather.fromJson(convert.jsonDecode(response.body));
      // return convert.jsonDecode(response.body);
    } else {
      print(
          "$className getWeather() failed with status ${response.statusCode}. ${response.body.toString()}");
      return Weather();
    }
  }

  Future<List<Region>> getRegion() async {
    var headers = {
      HttpHeaders.authorizationHeader:
          'Bearer ${await AuthService().getToken()}',
      HttpHeaders.contentTypeHeader: 'application/json'
    };
    var response =
        await http.get(Uri.parse('$_baseUrl/getRegion'), headers: headers);
    if (response.statusCode == 200) {
      return parseRegion(response.body);
      // return convert.jsonDecode(response.body);
    } else {
      print(
          "$className getRegion() failed with status ${response.statusCode}. ${response.body.toString()}");
      return <Region>[];
    }
  }

  Future<RainWeekly> findOneWeeklyCumulativeRain() async {
    var headers = {
      HttpHeaders.authorizationHeader:
          'Bearer ${await AuthService().getToken()}',
      HttpHeaders.contentTypeHeader: 'application/json'
    };
    var response = await http.get(
        Uri.parse('$_baseUrl/findOneWeeklyCumulativeRain'),
        headers: headers);
    if (response.statusCode == 200) {
      return RainWeekly.fromJson(convert.jsonDecode(response.body));
    } else {
      print(
          "$className findOneWeeklyCumulativeRain() failed with status ${response.statusCode}. ${response.body.toString()}");
      return RainWeekly();
    }
  }

  Future<RainMonthly> findOneCumulativeRain() async {
    var headers = {
      HttpHeaders.authorizationHeader:
          'Bearer ${await AuthService().getToken()}',
      HttpHeaders.contentTypeHeader: 'application/json'
    };
    var response = await http.get(Uri.parse('$_baseUrl/findOneCumulativeRain'),
        headers: headers);
    if (response.statusCode == 200) {
      return RainMonthly.fromJson(convert.jsonDecode(response.body));
    } else {
      print(
          "$className findOneCumulativeRain() failed with status ${response.statusCode}. ${response.body.toString()}");
      return RainMonthly();
    }
  }

  List<Region> parseRegion(String responseBody) {
    final parsed =
        convert.jsonDecode(responseBody)["data"].cast<Map<String, dynamic>>();
    return parsed.map<Region>((json) => Region.fromJson(json)).toList();
  }
}
