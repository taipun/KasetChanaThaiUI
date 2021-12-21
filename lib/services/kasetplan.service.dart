import 'dart:io';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:kasetchana_flutter/models/kasetplan.model.dart';
import 'package:kasetchana_flutter/models/plant.model.dart';
import 'package:kasetchana_flutter/services/auth.service.dart';
import 'package:kasetchana_flutter/utilities/globals.dart';

class KasetplanService {
  static const className = 'KasetplanService';
  var _baseUrl = '${Globals.API}';

  Future<List<Plant>> findAll() async {
    var headers = {
      HttpHeaders.authorizationHeader:
          'Bearer ${await AuthService().getToken()}',
      HttpHeaders.contentTypeHeader: 'application/json'
    };
    var response =
        await http.get(Uri.parse('$_baseUrl/plant'), headers: headers);
    if (response.statusCode == 200) {
      return parsePlant(response.body);
    } else {
      print(
          "$className findAll() failed with status ${response.statusCode}. ${response.body.toString()}");
      return <Plant>[];
    }
  }

  Future<Plant> findOne(String plantId) async {
    var headers = {
      HttpHeaders.authorizationHeader:
          'Bearer ${await AuthService().getToken()}',
      HttpHeaders.contentTypeHeader: 'application/json'
    };
    var response =
        await http.get(Uri.parse('$_baseUrl/plant/$plantId'), headers: headers);
    if (response.statusCode == 200) {
      return Plant.fromJson(convert.jsonDecode(response.body));
    } else {
      print(
          "$className findOne() failed with status ${response.statusCode}. ${response.body.toString()}");
      return Plant();
    }
  }

  Future<List<Kasetplan>> getKasetplan() async {
    var headers = {
      HttpHeaders.authorizationHeader:
          'Bearer ${await AuthService().getToken()}',
      HttpHeaders.contentTypeHeader: 'application/json'
    };
    var response =
        await http.get(Uri.parse('$_baseUrl/kasetplan'), headers: headers);
    if (response.statusCode == 200) {
      try {
        return parseKasetplan(response.body);
      } catch (ex) {
        print("$className ==> $ex");
        return <Kasetplan>[];
      }
    } else {
      print(
          "$className getKasetplan() failed with status ${response.statusCode}. ${response.body.toString()}");
      return <Kasetplan>[];
    }
  }

  Future<Kasetplan> getOneKasetplan() async {
    var headers = {
      HttpHeaders.authorizationHeader:
          'Bearer ${await AuthService().getToken()}',
      HttpHeaders.contentTypeHeader: 'application/json'
    };
    var response = await http.get(Uri.parse('$_baseUrl/getOneKasetplan'),
        headers: headers);
    if (response.statusCode == 200) {
      try {
        return Kasetplan.fromJson(convert.jsonDecode(response.body));
      } catch (ex) {
        print("$className ==> $ex");
        return Kasetplan();
      }
    } else {
      print(
          "$className getKasetplan() failed with status ${response.statusCode}. ${response.body.toString()}");
      return Kasetplan();
    }
  }

  Future<http.Response> createKasetplan(Kasetplan model) async {
    var headers = {
      HttpHeaders.authorizationHeader:
          'Bearer ${await AuthService().getToken()}',
      HttpHeaders.contentTypeHeader: 'application/json',
    };
    return await http.post(Uri.parse('$_baseUrl/kasetplan'),
        body: convert.jsonEncode(model.toJson()), headers: headers);
  }

  Future<http.Response> updateKasetplan(Kasetplan model) async {
    var headers = {
      HttpHeaders.authorizationHeader:
          'Bearer ${await AuthService().getToken()}',
      HttpHeaders.contentTypeHeader: 'application/json'
    };
    return await http.put(Uri.parse('$_baseUrl/kasetplan'),
        body: convert.jsonEncode(model.toJson()), headers: headers);
  }

  List<Plant> parsePlant(String responseBody) {
    final parsed =
        convert.jsonDecode(responseBody)["data"].cast<Map<String, dynamic>>();
    return parsed.map<Plant>((json) => Plant.fromJson(json)).toList();
  }

  List<Kasetplan> parseKasetplan(String responseBody) {
    final parsed =
        convert.jsonDecode(responseBody)["data"].cast<Map<String, dynamic>>();
    return parsed.map<Kasetplan>((json) => Kasetplan.fromJson(json)).toList();
  }
}
