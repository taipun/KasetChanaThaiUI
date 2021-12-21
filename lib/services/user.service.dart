import 'dart:io';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:kasetchana_flutter/models/user.model.dart';
import 'package:kasetchana_flutter/services/auth.service.dart';
import 'package:kasetchana_flutter/utilities/globals.dart';

class UserService {
  static const className = 'UserService';
  var _baseUrl = '${Globals.API}';

  Future<User> getUserByEmail(String email) async {
    var headers = {
      HttpHeaders.authorizationHeader:
          'Bearer ${await AuthService().getToken()}',
      HttpHeaders.contentTypeHeader: 'application/json'
    };
    var response = await http.get(Uri.parse('$_baseUrl/user?email=$email'),
        headers: headers);
    if (response.statusCode == 200) {
      return User.fromJson(convert.jsonDecode(response.body));
    } else {
      print(
          "$className getUserByEmail() failed with status ${response.statusCode}. ${response.body.toString()}");
      return User();
    }
  }

  Future<http.Response> create(User model) async {
    var headers = {
      HttpHeaders.authorizationHeader:
      'Bearer ${await AuthService().getToken()}',
      HttpHeaders.contentTypeHeader: 'application/json'
    };
    return await http.post(Uri.parse('$_baseUrl/signup'),
        body: convert.jsonEncode(model.toJson()), headers: headers);
  }

  Future<http.Response> update(User model) async {
    var headers = {
      HttpHeaders.authorizationHeader:
          'Bearer ${await AuthService().getToken()}',
      HttpHeaders.contentTypeHeader: 'application/json'
    };
    return await http.put(Uri.parse('$_baseUrl/user'),
        body: convert.jsonEncode(model.toJson()), headers: headers);
  }
}
