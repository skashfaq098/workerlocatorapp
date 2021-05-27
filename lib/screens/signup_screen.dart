import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:group_radio_button/group_radio_button.dart';
import 'package:provider/provider.dart';
import 'package:workerlocatorapp/helpers/customcliptwo.dart';
import 'package:workerlocatorapp/providers/auth.dart';
import 'package:workerlocatorapp/screens/login_screen.dart';
import 'package:workerlocatorapp/utils/http_exception.dart';
import '../helpers/customclipone.dart';
import 'package:http/http.dart' as http;

enum SignInType { worker, recruiter }

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  String name = "";
  String email = "";
  String pass = "";
  String passConfirm = "";
  String role = "worker";
  bool isRegistered = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  void _showerrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          'Alert',
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

  Future<void> _submit(String name, String email, String pass,
      String passConfirm, String role) async {
    try {
      final response = await http.post(
        Uri.https('worker-arfaz-test.herokuapp.com', '/api/v1/users/signUp'),
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
      if (response.statusCode == 201) {
        _showerrorDialog("Registered");
      }
      if (responceData['error'] != null) {
        throw HttpException(responceData['error']['message']);
      }
    } catch (e) {
      throw e;
    }
  }

  // Future _submit(String name, String email, String pass, String passConfirm,
  //     String role) async {
  //   try {
  //     await Provider.of<Auth>(context, listen: false)
  //         .signUp(name, email, pass, passConfirm, role);
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

  @override
  Widget build(BuildContext context) {
    print(role);
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Container(
            child: Stack(
              children: [
                ClipPath(
                  clipper: CustomClipOne(),
                  child: Container(
                    height: height,
                    width: width,
                    decoration: BoxDecoration(
                      color: Color(0xff48dbfb).withOpacity(0.5),
                    ),
                  ),
                ),
                ClipPath(
                  clipper: CustomClipTwo(),
                  child: Container(
                    height: height,
                    width: width,
                    decoration: BoxDecoration(
                      color: Color(0xff0abde3),
                    ),
                  ),
                ),
                Container(
                  height: height,
                  width: width,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 40.0, top: 150),
                          child: Text(
                            "Create",
                            style: GoogleFonts.raleway(
                                fontSize: 40,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 40.0, top: 0),
                          child: Text(
                            "Account",
                            style: GoogleFonts.raleway(
                                fontSize: 40,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                          padding:
                              EdgeInsets.only(left: 40, top: 120, right: 50),
                          child: TextFormField(
                              decoration: const InputDecoration(
                                labelText: 'Full Name',
                              ),
                              validator: (String value) {
                                if (value.trim().isEmpty) {
                                  return 'Full Name is required';
                                }
                              },
                              onChanged: (newValue) => name = newValue),
                        ),
                        Padding(
                          padding:
                              EdgeInsets.only(left: 40, top: 10, right: 50),
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
                        Padding(
                          padding:
                              EdgeInsets.only(left: 40, top: 10, right: 50),
                          child: TextFormField(
                            onChanged: (newValue) => pass = newValue,
                            obscureText: true,
                            decoration: const InputDecoration(
                              labelText: 'Password',
                            ),
                            validator: (String value) {
                              if (value.trim().isEmpty) {
                                return 'Password is required';
                              }
                            },
                          ),
                        ),
                        Padding(
                          padding:
                              EdgeInsets.only(left: 40, top: 10, right: 50),
                          child: TextFormField(
                            onChanged: (newValue) => passConfirm = newValue,
                            decoration: const InputDecoration(
                              labelText: 'Confirm Password',
                            ),
                            validator: (String value) {
                              if (value.trim().isEmpty) {
                                return 'Confirm Password is required';
                              }
                            },
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              RadioButton(
                                description: "Worker",
                                value: "worker",
                                groupValue: role,
                                onChanged: (value) => setState(
                                  () => role = value,
                                ),
                                activeColor: Colors.red,
                              ),
                              RadioButton(
                                description: "Recruiter",
                                value: "recruiter",
                                groupValue: role,
                                onChanged: (value) => setState(
                                  () => role = value,
                                ),

                                // Container(
                                //   width: width / 2 - 40,
                                //   child: RadioListTile<SignInType>(
                                //     activeColor: Color(0xff0abde3),
                                //     title: const Text("Worker"),
                                //     value: SignInType.worker,
                                //     groupValue: _signInType,
                                //     onChanged: (SignInType value) {
                                //       setState(() {
                                //         _signInType = value;
                                //       });
                                //     },
                                //   ),
                                // ),
                                // Container(
                                //   width: width / 2 - 40,
                                //   child: RadioListTile<SignInType>(
                                //     activeColor: Color(0xff0abde3),
                                //     title: const Text("Recruiter"),
                                //     value: SignInType.recruiter,
                                //     groupValue: _signInType,
                                //     onChanged: (SignInType value) {
                                //       setState(() {
                                //         _signInType = value;
                                //       });
                                //     },
                                //   ),
                                // ),
                              )
                            ]),
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 40, bottom: 30),
                            child: TextButton(
                              // padding: EdgeInsets.only(top: 40, bottom: 30),
                              onPressed: null,
                              child: Material(
                                elevation: 10,
                                borderRadius: BorderRadius.circular(12),
                                child: GestureDetector(
                                  onTap: () {
                                    _submit(
                                        name, email, pass, passConfirm, role);
                                  },
                                  child: Container(
                                    width: 200,
                                    decoration: BoxDecoration(
                                        color: Color(0xff0abde3),
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                            color: Color(0xff31b8b1)
                                                .withOpacity(0.5),
                                            width: 2)),
                                    height: 40,
                                    child: Center(
                                      child: const Text(
                                        'Register',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Center(
                          child: Text(
                            "Already got Account?",
                            style: GoogleFonts.raleway(
                                fontSize: 18,
                                color: Color(0xff0abde3),
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Center(
                          child: ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text(
                                "Login",
                              )),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
