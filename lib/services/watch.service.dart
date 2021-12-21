import 'dart:io';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:kasetchana_flutter/models/watch.model.dart';
import 'package:kasetchana_flutter/utilities/globals.dart';

import 'auth.service.dart';

class WatchService {
  static const className = 'WatchService';
  var _baseUrl = '${Globals.API}';

  Future<http.Response> create(Watch model) async {
    var headers = {
      HttpHeaders.authorizationHeader:
          'Bearer ${await AuthService().getToken()}',
      HttpHeaders.contentTypeHeader: 'application/json',
    };
    return await http.post(Uri.parse('$_baseUrl/watchlist'),
        body: convert.jsonEncode(model), headers: headers);
  }

  Future<http.Response> update(Watch model) async {
    var headers = {
      HttpHeaders.authorizationHeader:
          'Bearer ${await AuthService().getToken()}',
      HttpHeaders.contentTypeHeader: 'application/json',
    };
    return await http.put(Uri.parse('$_baseUrl/watchlist'),
        body: convert.jsonEncode(model), headers: headers);
  }

  Future<Watch> findOne(int no) async {
    var headers = {
      HttpHeaders.authorizationHeader:
          'Bearer ${await AuthService().getToken()}',
      HttpHeaders.contentTypeHeader: 'application/json'
    };
    var response = await http.get(Uri.parse('$_baseUrl/watchlist?no=$no'),
        headers: headers);
    if (response.statusCode == 200) {
      return Watch.fromJson(convert.jsonDecode(response.body));
    } else {
      print(
          "$className findOne() failed with status ${response.statusCode}. ${response.body.toString()}");
      return Watch();
    }
  }
}
