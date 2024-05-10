import 'dart:convert';
import 'dart:io';
import 'dart:async';

import 'package:http/http.dart';
import 'package:http/io_client.dart';
import 'package:flutter/foundation.dart';
import '../models/storageService.dart';
import '../globals.dart';

abstract class BaseProvider<T> with ChangeNotifier {
  String? _endpoint;

  HttpClient client = HttpClient();
  IOClient? http;

  BaseProvider(String endpoint) {
    _endpoint = endpoint;
    client.badCertificateCallback = (cert, host, port) => true;
    http = IOClient(client);
  }

  Future<List<T>> getAll() async {
    var url = "$baseUrl$_endpoint/GetAll";
    var uri = Uri.parse(url);

    Map<String, String> headers = createHeaders();

    var response = await http!.get(uri, headers: headers);

    if (isValidResponseCode(response)) {
      var data = jsonDecode(response.body);
      return data.map((x) => fromJson(x)).cast<T>().toList();
    } else {
      throw Exception("Failed to fetch data");
    }
  }

  Future<T?> getById(int id) async {
    var url = "$baseUrl$_endpoint/GetById?id=$id";
    var uri = Uri.parse(url);

    Map<String, String> headers = createHeaders();

    var response = await http!.get(uri, headers: headers);

    if (isValidResponseCode(response)) {
      var data = jsonDecode(response.body);
      return fromJson(data);
    } else {
      throw Exception("Failed to fetch data");
    }
  }

  Future<dynamic> create(dynamic request) async {
    var url = "$baseUrl$_endpoint/Create";
    var uri = Uri.parse(url);

    Map<String, String> headers = createHeaders();

    var jsonRequest = jsonEncode(request);
    var response = await http!.post(uri, headers: headers, body: jsonRequest);

    if (isValidResponseCode(response)) {
      var data = response.body;
      return data;
    } else {
      throw Exception("Failed to create data");
    }
  }

  Future<T?> update(dynamic request) async {
    var url = "$baseUrl$_endpoint/Update";
    var uri = Uri.parse(url);

    Map<String, String> headers = createHeaders();

    var jsonRequest = jsonEncode(request);
    var response = await http!.put(uri, headers: headers, body: jsonRequest);

    if (isValidResponseCode(response)) {
      var data = jsonDecode(response.body);
      return fromJson(data);
    } else {
      throw Exception("Failed to update data");
    }
  }

  Future<void> delete(int id) async {
    var url = "$baseUrl$_endpoint/Delete?id=$id";
    var uri = Uri.parse(url);

    Map<String, String> headers = createHeaders();

    var response = await http!.delete(uri, headers: headers);

    if (!isValidResponseCode(response)) {
      throw Exception("Failed to delete data");
    }
  }

  Map<String, String> createHeaders() {
    String? token = StorageService.token;

    String basicAuth = "Bearer $token";

    var headers = {
      "Content-Type": "application/json",
      "Authorization": basicAuth
    };
    return headers;
  }

  T fromJson(data) {
    throw Exception("Override method");
  }

  bool isValidResponseCode(Response response) {
    if (response.statusCode == 200) {
      if (response.body != "") {
        return true;
      } else {
        return false;
      }
    } else if (response.statusCode == 204) {
      return true;
    } else if (response.statusCode == 400) {
      throw Exception(response.body);
    } else if (response.statusCode == 401) {
      throw Exception("Unauthorized");
    } else if (response.statusCode == 403) {
      throw Exception("Forbidden");
    } else if (response.statusCode == 404) {
      throw Exception("Not found");
    } else if (response.statusCode == 500) {
      throw Exception("Internal server error");
    } else {
      throw Exception("Exception... handle this gracefully");
    }
  }
}
