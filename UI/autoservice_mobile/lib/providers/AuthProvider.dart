import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/storageService.dart';
import '../globals.dart';

class AuthProvider {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<StorageService?> login(String username, String password) async {
    final String loginUrl = "${baseUrl}Authentication/Login";

    final response = await http.post(
      Uri.parse(loginUrl),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'username': username,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonData = json.decode(response.body);
      final StorageService storageService = StorageService.fromJson(jsonData);
      final String token = jsonData['token'];

      await _storage.write(key: 'token', value: token);

      StorageService.token = token;

      return storageService;
    } else {
      return null;
    }
  }

  Future<void> logout(BuildContext context) async {
    await _storage.deleteAll();
    Navigator.of(context, rootNavigator: true).pushNamedAndRemoveUntil(
      '/',
      (_) => false,
    );
  }
}
