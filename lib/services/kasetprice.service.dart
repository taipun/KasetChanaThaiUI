import 'dart:io';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:kasetchana_flutter/models/kaset-product-price.model.dart';
import 'package:kasetchana_flutter/models/kaset-product.model.dart';
import 'package:kasetchana_flutter/services/auth.service.dart';
import 'package:kasetchana_flutter/utilities/globals.dart';

class KasetPriceService {
  static const className = 'KasetPriceService';
  var _baseUrl = '${Globals.API}';

  Future<List<KasetProductGroup>> findAllGroup() async {
    var headers = {
      HttpHeaders.authorizationHeader:
          'Bearer ${await AuthService().getToken()}',
      HttpHeaders.contentTypeHeader: 'application/json'
    };
    var response =
        await http.get(Uri.parse('$_baseUrl/product-group'), headers: headers);
    if (response.statusCode == 200) {
      return parseKasetProductGroup(response.body);
    } else {
      print(
          "$className findAllGroup() failed with status ${response.statusCode}. ${response.body.toString()}");
      return <KasetProductGroup>[];
    }
  }

  Future<List<KasetProduct>> findAll(String keyword) async {
    var headers = {
      HttpHeaders.authorizationHeader:
          'Bearer ${await AuthService().getToken()}',
      HttpHeaders.contentTypeHeader: 'application/json'
    };
    var response = await http.get(
        Uri.parse('$_baseUrl/product?product_name=$keyword'),
        headers: headers);
    // var response = await http.get(
    //     Uri.parse('$_baseUrl/kaset-products?keyword=$keyword'),
    //     headers: headers);
    if (response.statusCode == 200) {
      return parseKasetProduct(response.body);
    } else {
      print(
          "$className findAll() failed with status ${response.statusCode}. ${response.body.toString()}");
      return <KasetProduct>[];
    }
  }

  Future<List<KasetProduct>> getProductByGroup(String group) async {
    var headers = {
      HttpHeaders.authorizationHeader:
          'Bearer ${await AuthService().getToken()}',
      HttpHeaders.contentTypeHeader: 'application/json'
    };
    var response = await http.get(
        Uri.parse('$_baseUrl/product-by-group?group=$group'),
        headers: headers);
    if (response.statusCode == 200) {
      return parseKasetProduct(response.body);
    } else {
      print(
          "$className getProductByGroup() failed with status ${response.statusCode}. ${response.body.toString()}");
      return <KasetProduct>[];
    }
  }

  Future<KasetProductPrice> findOnePrice(String productId, String date) async {
    var headers = {
      HttpHeaders.authorizationHeader:
          'Bearer ${await AuthService().getToken()}',
      HttpHeaders.contentTypeHeader: 'application/json'
    };
    var response = await http.get(
        Uri.parse('$_baseUrl/kaset-price?productId=$productId&date=$date'),
        headers: headers);
    if (response.statusCode == 200) {
      return KasetProductPrice.fromJson(convert.jsonDecode(response.body));
    } else {
      print(
          "$className findOnePrice() failed with status ${response.statusCode}. ${response.body.toString()}");
      return KasetProductPrice();
    }
  }

  Future<double> getPrice(String productId, String date) async {
    var headers = {
      HttpHeaders.authorizationHeader:
          'Bearer ${await AuthService().getToken()}',
      HttpHeaders.contentTypeHeader: 'application/json'
    };
    var response = await http.get(
        Uri.parse('$_baseUrl/kaset-price?productId=$productId&date=$date'),
        headers: headers);
    if (response.statusCode == 200) {
      return KasetProductPrice.fromJson(convert.jsonDecode(response.body))
          .price;
    } else {
      print(
          "$className findOnePrice() failed with status ${response.statusCode}. ${response.body.toString()}");
      return 0;
    }
  }

  List<KasetProduct> parseKasetProduct(String responseBody) {
    final parsed =
        convert.jsonDecode(responseBody)["data"].cast<Map<String, dynamic>>();
    return parsed
        .map<KasetProduct>((json) => KasetProduct.fromJson(json))
        .toList();
  }

  List<KasetProductGroup> parseKasetProductGroup(String responseBody) {
    final parsed =
        convert.jsonDecode(responseBody)["data"].cast<Map<String, dynamic>>();
    return parsed
        .map<KasetProductGroup>((json) => KasetProductGroup.fromJson(json))
        .toList();
  }
}
