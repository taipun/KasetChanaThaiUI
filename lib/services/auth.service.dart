import 'dart:io';
import 'dart:convert' as convert;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:kasetchana_flutter/models/user.model.dart';
import 'package:kasetchana_flutter/utilities/globals.dart';

class AuthService {
  final _storage = FlutterSecureStorage();
  static const className = 'AuthService';
  var _baseUrl = '${Globals.API}';

  Future<http.Response> login(String email, String pass) async {
    var headers = {HttpHeaders.contentTypeHeader: 'application/json'};
    return await http.post(Uri.parse('$_baseUrl/login'),
        body: convert.jsonEncode({'email': email, 'password': pass}),
        headers: headers);
  }

  Future<http.Response> register(User model) async {
    var headers = {HttpHeaders.contentTypeHeader: 'application/json'};
    return await http.post(Uri.parse('$_baseUrl/users'),
        body: convert.jsonEncode(model.toJson()), headers: headers);
  }

  Future<http.Response> forgotPassword(String email) async {
    var headers = {HttpHeaders.contentTypeHeader: 'application/json'};
    return await http.post(Uri.parse('$_baseUrl/forget'),
        body: convert.jsonEncode({'email': email}), headers: headers);
  }

  Future<http.StreamedResponse> uploadImage(String file) async {
    try {
      print(await this.getToken());
      var request =
          http.MultipartRequest('POST', Uri.parse('$_baseUrl/images'));
      var headers = {
        HttpHeaders.authorizationHeader: 'Bearer ${await this.getToken()}'
      };
      request.files.add(await http.MultipartFile.fromPath('photo', file));
      request.headers.addAll(headers);
      http.StreamedResponse res = await request.send();
      return res;
    } catch (e) {
      print(
          "$className uploadImage(String file) failed with status ${e.toString()}");
    }
  }

  void setRemember(String check) {
    _storage.write(key: 'remember', value: check);
  }

  Future<String> getRemember() async {
    return await _storage.read(key: 'remember');
  }

  void setToken(String token) {
    _storage.write(key: 'token', value: token);
  }

  void removeToken() {
    _storage.deleteAll();
  }

  Future<String> getToken() async {
    return await _storage.read(key: 'token');
  }

  Map<String, dynamic> _parseJwt(String token) {
    final parts = token.split('.');
    if (parts.length != 3) {
      throw Exception('invalid token');
    }

    final payload = _decodeBase64(parts[1]);

    final payloadMap = convert.jsonDecode(payload);
    if (payloadMap is! Map<String, dynamic>) {
      throw Exception('invalid payload');
    }
    return payloadMap;
  }

  String _decodeBase64(String str) {
    String output = str.replaceAll('-', '+').replaceAll('_', '/');

    switch (output.length % 4) {
      case 0:
        break;
      case 2:
        output += '==';
        break;
      case 3:
        output += '=';
        break;
      default:
        throw Exception('Illegal base64url string!"');
    }

    return convert.utf8.decode(convert.base64Url.decode(output));
  }

  Future<String> decodeEmail() async {
    var token = await this.getToken();
    return this._parseJwt(token)['email'];
  }
}
