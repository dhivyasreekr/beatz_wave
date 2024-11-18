import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart' as Dio;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/User.dart';
import '../utils/Constants.dart';
import 'dio.dart';

import 'package:http/http.dart' as http;

class Auth extends ChangeNotifier {

  bool _isLoggedIn = false;
  User? _user;
  String? _token;

  bool get authenticated => _isLoggedIn;
  User? get user => _user;

  // Flutter Secure Storage
  final storage = FlutterSecureStorage();

  void login({required Map creds}) async {
    print(creds);

    try {
      Dio.Response response = await dio().post(Constants.LOGIN_ROUTE, data: creds);
      print(response.data);

      String token = response.data.toString();
      tryToken(token: token);
      _isLoggedIn = true;
      notifyListeners();
    } catch (e) {
      print('Login Error: $e ${Constants.BASE_URL}${Constants.LOGIN_ROUTE}');
      // Handle the error appropriately (show a message, etc.)
    }
  }

  void tryToken({required String token}) async {
    if (token.isEmpty) {
      return;
    } else {
      try {
        Dio.Response response = await dio().get(
          '/user',
          options: Dio.Options(headers: {'Authorization': 'Bearer $token'}),
        );

        _isLoggedIn = true;
        _user = User.fromJson(response.data);
        _token = token;

        storeToken(token: token);
        notifyListeners();

        print(_user);
      } catch (e) {
        print("Error fetching user data: $e");
      }
    }
  }

  void storeToken({required String token}) async {
    await storage.write(key: 'token', value: token);
  }

  void logout() async {
    dynamic token = await storage.read(key: 'token');

    try {
      print('Logout started');

      Dio.Response response = await dio().post(
        Constants.LOGOUT_ROUTE,
        options: Dio.Options(headers: {'Authorization': 'Bearer $token'}),
      );

      print(response.data);

      cleanUp();
      notifyListeners();

      print('Logout ended');
    } catch (e) {
      print('Logout Error: $e');
      print(Constants.LOGOUT_ROUTE);
    }
  }

  void cleanUp() async {
    _user = null;
    _isLoggedIn = false;
    _token = null;

    await storage.delete(key: 'token');
  }

  Future<void> registerUser({required Map creds}) async {
    try {
      final response = await http.post(
        Uri.parse(Constants.BASE_URL + Constants.USER_REGISTER_ROUTE),
        body: creds,
      );

      if (response.statusCode == 201) {
        // Registration successful
        Map<String, dynamic> responseData = json.decode(response.body);
        print('User registered successfully: ${responseData['user']['name']}');
      } else {
        // Registration failed
        print('Registration failed: ${response.body}');
      }
    } catch (e) {
      print('Error during registration: $e');
    }

    await Future.delayed(Duration(seconds: 2));
    notifyListeners();
  }
}