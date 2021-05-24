import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:workerlocatorapp/helpers/text_form_field_helper.dart';
import 'package:workerlocatorapp/screens/login_screen.dart';
import 'dart:convert';

import 'package:workerlocatorapp/utils/http_exception.dart';

class ForgetPassword extends StatefulWidget {
  @override
  _ForgetPasswordState createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  Future<void> forgetPass(
    String email,
  ) async {
    try {
      final response = await http.post(
        Uri.https(
            'worker-arfaz-test.herokuapp.com', '/api/v1/users/forgotPassword'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          // 'Authorization': 'Bearer $token',
        },
        body: jsonEncode(<String, String>{
          "email": email,
        }),
      );

      final resData = json.decode(response.body);
      print(response.body);

      if (response.statusCode == 200) {
        print(jsonDecode(response.body));

        return jsonDecode(response.body);
      } else {
        throw HttpException(resData['message']);
      }
    } on HttpException catch (error) {
      // print("my exceptioncatch");
      // showErrorDialog(error.toString());
      // print(error.toString());
    }
  }

  void showErrorDialog(String message) {
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              title: Text('Failed'),
              content: Text(message),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('okay'))
              ],
            ));
  }

  final _formKey = GlobalKey<FormState>();
  String email;
  final _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Forget Password'),
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
                      onChanged: (newValue) => email = newValue,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                      ),
                      validator: (String value) {
                        if (value.trim().isEmpty) {
                          return 'Email is required';
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
                          forgetPass(email);
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
