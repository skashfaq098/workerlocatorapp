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
  String _phone;

  bool get isAuth {
    return token != null;
  }

  bool get isPhone {
    return _phone != null;
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

    final response = await http.get(
      Uri.https(
          'worker-arfaz-test.herokuapp.com', '/api/v1/users/getMyDetails'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $_token',
      },
    );

    final resData = json.decode(response.body);
    _userEmail = extractedUserData['userEmail'];

    print(response.body);

    if (response.statusCode == 200) {
      print(jsonDecode(response.body));
    }
    if (response.body == null) {
      return false;
    }
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
      String usersEmail = "";
      final userData = json.encode({
        'token': _token,
        'userEmail': email,
      });
      prefs.setString('token', _token);
      prefs.setString('userData', userData);
      prefs.setString('usersEmail', email);

      print('check' + usersEmail);
    } catch (e) {
      throw e;
    }
  }

  Future<void> VerifyOTP(String phone, String code) async {
    String token = "";
    final prefs = await SharedPreferences.getInstance();
    token = (prefs.getString('token') ?? '');
    try {
      final response = await http.post(
        Uri.https(
            'worker-arfaz-test.herokuapp.com', '/api/v1/verifyPhone/verifyOtp'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(<String, String>{
          "phone": phone,
          "code": code,
        }),
      );

      final responceData = json.decode(response.body);
      print(responceData);
      if (responceData['error'] != null) {
        throw HttpException(responceData['error']['message']);
      }
      notifyListeners();
    } catch (e) {
      throw e;
    }
  }

  Future<void> SendOTP(String phone) async {
    String token = "";
    final prefs = await SharedPreferences.getInstance();
    token = (prefs.getString('token') ?? '');
    try {
      final response = await http.post(
        Uri.https(
            'worker-arfaz-test.herokuapp.com', '/api/v1/verifyPhone/sendOtp'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(<String, String>{
          "phone": phone,
        }),
      );

      final responceData = json.decode(response.body);
      if (response.statusCode == 201) {
        prefs.setString('phone', phone);
        _phone = phone;
      }
      print(responceData);
      if (responceData['error'] != null) {
        throw HttpException(responceData['error']['message']);
      }
      notifyListeners();
    } catch (e) {
      throw e;
    }
  }

  Future<void> AuthenticationRegister(String name, String email, String pass,
      String passConfirm, String role, String endpoint) async {
    try {
      final response = await http.post(
        Uri.https('worker-arfaz-test.herokuapp.com', '/api/v1/users/$endpoint'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          "name": name,
          "email": email,
          "password": pass,
          "passwordConfirm": passConfirm,
          "role": role
        }),
      );

      final responceData = json.decode(response.body);
      print(responceData);
      if (responceData['error'] != null) {
        throw HttpException(responceData['error']['message']);
      }
      _token = responceData['data']['token'];
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

  Future<void> signUp(
      String name, String email, String pass, String passConfirm, String role) {
    return AuthenticationRegister(
        name, email, pass, passConfirm, role, 'signUp');
  }

  Future<void> sendOTP(String phone) {
    return SendOTP(phone);
  }

  Future<void> verifyOTP(String phone, String code) {
    return VerifyOTP(phone, code);
  }
}
