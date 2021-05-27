import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workerlocatorapp/providers/auth.dart';
import 'package:workerlocatorapp/utils/http_exception.dart';
import 'package:http/http.dart' as http;

class VerifyOTP extends StatefulWidget {
  final String id;
  const VerifyOTP({Key key, this.id}) : super(key: key);

  @override
  _VerifyOTPState createState() => _VerifyOTPState();
}

class _VerifyOTPState extends State<VerifyOTP> {
  String phone = "";
  void initState() {
    super.initState();
    _loadCounter();
  }

  _loadCounter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      phone = widget.id;
    });
    print(phone);
  }

  void _showerrorDialog(String message) {
    print(message);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          'An Error Occurs',
          style: TextStyle(color: Colors.blue),
        ),
        content: Text(message),
        actions: <Widget>[
          FlatButton(
            child: Text('Okay'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          )
        ],
      ),
    );
  }

  // Future _verifyOTP(String phone, String code) async {
  //   try {
  //     await Provider.of<Auth>(context, listen: false).verifyOTP(phone, code);
  //   } on HttpException catch (e) {
  //     var errorMessage = 'Authentication Failed';
  //     if (e.toString().contains('INVALID_EMAIL')) {
  //       errorMessage = 'Invalid email';
  //       _showerrorDialog(errorMessage);
  //     } else if (e.toString().contains('EMAIL_NOT_FOUND')) {
  //       errorMessage = 'This email not found';
  //       _showerrorDialog(errorMessage);
  //     } else if (e.toString().contains('INVALID_PASSWORD')) {
  //       errorMessage = 'Invalid Password';
  //       _showerrorDialog(errorMessage);
  //     }
  //   } catch (error) {
  //     var errorMessage = 'Plaese try again later';
  //     _showerrorDialog(errorMessage);
  //   }
  // }
  Future<void> _verifyOTP(String phone, String code) async {
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
      if (response.statusCode == 201) {
        _showerrorDialog("Mobile Number Verified");
      }
      if (responceData['error'] != null) {
        throw HttpException(responceData['error']['message']);
      }
    } catch (e) {
      throw e;
    }
  }

  final _formKey = GlobalKey<FormState>();
  String code;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Verify OTP'),
        backgroundColor: Color(0xff0abde3),
        elevation: 0.0,
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Center(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 40, top: 10, right: 50),
                    child: TextFormField(
                      onChanged: (newValue) => code = newValue,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                      ),
                      validator: (String value) {
                        if (value.trim().isEmpty) {
                          return 'Phone number is required';
                        }
                      },
                    ),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _verifyOTP(phone, code);
                        });
                      },
                      child: Text('Submit')),
                ],
              ),
            ),
          ),
        ),
      )),
    );
  }
}
