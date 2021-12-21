import 'dart:io';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:kasetchana_flutter/models/port-log.model.dart';
import 'package:kasetchana_flutter/utilities/globals.dart';

import 'auth.service.dart';

class PortLogService {
  static const className = 'PortLogService';
  var _baseUrl = '${Globals.API}';

  Future<http.Response> create(PortLog model) async {
    var headers = {
      HttpHeaders.authorizationHeader:
          'Bearer ${await AuthService().getToken()}',
      HttpHeaders.contentTypeHeader: 'application/json',
    };
    return await http.post(Uri.parse('$_baseUrl/portlogs'),
        body: convert.jsonEncode(model), headers: headers);
  }

  Future<http.Response> update(PortLog model) async {
    var headers = {
      HttpHeaders.authorizationHeader:
          'Bearer ${await AuthService().getToken()}',
      HttpHeaders.contentTypeHeader: 'application/json',
    };
    return await http.put(Uri.parse('$_baseUrl/portlogs'),
        body: convert.jsonEncode(model), headers: headers);
  }

  Future<List<PortLog>> findAll() async {
    var headers = {
      HttpHeaders.authorizationHeader:
          'Bearer ${await AuthService().getToken()}',
      HttpHeaders.contentTypeHeader: 'application/json'
    };
    var response =
        await http.get(Uri.parse('$_baseUrl/portlogs'), headers: headers);
    if (response.statusCode == 200) {
      return parsePortLog(response.body);
    } else {
      print(
          "$className findAll() failed with status ${response.statusCode}. ${response.body.toString()}");
      return <PortLog>[];
    }
  }

  List<PortLog> parsePortLog(String responseBody) {
    final parsed =
        convert.jsonDecode(responseBody)["data"].cast<Map<String, dynamic>>();
    return parsed.map<PortLog>((json) => PortLog.fromJson(json)).toList();
  }
}
