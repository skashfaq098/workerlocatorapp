import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workerlocatorapp/utils/api.dart';
import 'package:workerlocatorapp/utils/http_exception.dart';

class Auth with ChangeNotifier {
  var MainUrl = Api.authUrl;

  String _token;
  String _userEmail;

  bool get isAuth {
    return token != null;
  }

  String get token {
    if (_token != null) {
      return _token;
    }
  }

  String get userEmail {
    return _userEmail;
  }

  Future<void> logout() async {
    _token = null;
    _userEmail = null;

    notifyListeners();

    final pref = await SharedPreferences.getInstance();
    pref.clear();
  }

  Future<bool> tryautoLogin() async {
    final pref = await SharedPreferences.getInstance();
    if (!pref.containsKey('userData')) {
      return false;
    }

    final extractedUserData =
        json.decode(pref.getString('userData')) as Map<String, Object>;

    _token = extractedUserData['token'];
    _userEmail = extractedUserData['userEmail'];
    notifyListeners();
    return true;
  }

  Future<void> Authentication(
      String email, String password, String endpoint) async {
    try {
      final response = await http.post(
        Uri.https('worker-arfaz-test.herokuapp.com', '/api/v1/users/$endpoint'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          "email": email,
          "password": password,
        }),
      );

      final responceData = json.decode(response.body);
      print(responceData);
      if (responceData['error'] != null) {
        throw HttpException(responceData['error']['message']);
      }
      _token = responceData['token'];
      _userEmail = responceData['email'];
      notifyListeners();

      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode({
        'token': _token,
        'userEmail': _userEmail,
      });

      prefs.setString('userData', userData);

      print('check' + userData.toString());
    } catch (e) {
      throw e;
    }
  }

  Future<void> login(String email, String password) {
    return Authentication(email, password, 'signIn');
  }

  Future<void> signUp(String email, String password) {
    return Authentication(email, password, 'signUp');
  }
}
