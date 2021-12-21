import 'dart:io';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:kasetchana_flutter/models/portfolio.model.dart';
import 'package:kasetchana_flutter/utilities/globals.dart';

import 'auth.service.dart';

class PortfolioService {
  static const className = 'PortfolioService';
  var _baseUrl = '${Globals.API}';

  Future<http.Response> create(Portfolio model) async {
    var headers = {
      HttpHeaders.authorizationHeader:
          'Bearer ${await AuthService().getToken()}',
      HttpHeaders.contentTypeHeader: 'application/json',
    };
    return await http.post(Uri.parse('$_baseUrl/portfolio'),
        body: convert.jsonEncode(model), headers: headers);
  }

  Future<http.Response> update(Portfolio model) async {
    var headers = {
      HttpHeaders.authorizationHeader:
          'Bearer ${await AuthService().getToken()}',
      HttpHeaders.contentTypeHeader: 'application/json',
    };
    return await http.put(Uri.parse('$_baseUrl/portfolio'),
        body: convert.jsonEncode(model), headers: headers);
  }

  Future<Portfolio> findOne() async {
    var headers = {
      HttpHeaders.authorizationHeader:
          'Bearer ${await AuthService().getToken()}',
      HttpHeaders.contentTypeHeader: 'application/json'
    };
    var response =
        await http.get(Uri.parse('$_baseUrl/portfolio'), headers: headers);
    if (response.statusCode == 200) {
      return Portfolio.fromJson(convert.jsonDecode(response.body));
    } else {
      print(
          "$className findOne() failed with status ${response.statusCode}. ${response.body.toString()}");
      return Portfolio();
    }
  }

  Future<int> getSummaryItems() async {
    var headers = {
      HttpHeaders.authorizationHeader:
          'Bearer ${await AuthService().getToken()}',
      HttpHeaders.contentTypeHeader: 'application/json'
    };
    var response = await http.get(Uri.parse('$_baseUrl/getSummaryItems'),
        headers: headers);
    if (response.statusCode == 200) {
      return convert.jsonDecode(response.body)[0];
    } else {
      print(
          "$className findOne() failed with status ${response.statusCode}. ${response.body.toString()}");
      return 0;
    }
  }
}
