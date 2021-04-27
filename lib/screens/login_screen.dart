import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:workerlocatorapp/providers/auth.dart';
import 'package:workerlocatorapp/screens/forget_password.dart';
import 'package:workerlocatorapp/screens/signup_screen.dart';
import 'package:workerlocatorapp/utils/http_exception.dart';
import '../helpers/customcliptwo.dart';
import '../helpers/customclipone.dart';
import 'package:http/http.dart' as http;

import '../main.dart';
import '../main.dart';
import '../main.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  Map<String, String> _authData = {'email': '', 'password': ''};
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

  Future _submit(String email, String pass) async {
    try {
      await Provider.of<Auth>(context, listen: false).login(email, pass);
    } on HttpException catch (e) {
      var errorMessage = 'Authentication Failed';
      if (e.toString().contains('INVALID_EMAIL')) {
        errorMessage = 'Invalid email';
        _showerrorDialog(errorMessage);
      } else if (e.toString().contains('EMAIL_NOT_FOUND')) {
        errorMessage = 'This email not found';
        _showerrorDialog(errorMessage);
      } else if (e.toString().contains('INVALID_PASSWORD')) {
        errorMessage = 'Invalid Password';
        _showerrorDialog(errorMessage);
      }
    } catch (error) {
      var errorMessage = 'Plaese try again later';
      _showerrorDialog(errorMessage);
    }
  }

  String email = "";
  String pass = "";
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SingleChildScrollView(
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 40.0, top: 150),
                    child: Text(
                      "Welcome",
                      style: GoogleFonts.raleway(
                          fontSize: 40,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 40.0, top: 0),
                    child: Text(
                      "Back",
                      style: GoogleFonts.raleway(
                          fontSize: 40,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 40, top: 120, right: 50),
                    child: TextFormField(
                      onChanged: (value) => email = value,
                      decoration: InputDecoration(
                          hintText: 'Email address',
                          hintStyle: GoogleFonts.raleway(color: Colors.grey),
                          contentPadding: EdgeInsets.only(top: 15, bottom: 15),
                          enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.grey[300], width: 2.0)),
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color(0xff46ddbf), width: 1.0))),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 40, top: 10, right: 50),
                    child: TextFormField(
                      onChanged: (value) => pass = value,
                      decoration: InputDecoration(
                          hintText: 'Password',
                          hintStyle: GoogleFonts.raleway(color: Colors.grey),
                          contentPadding: EdgeInsets.only(top: 15, bottom: 15),
                          enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.grey[300], width: 2.0)),
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color(0xff46ddbf), width: 1.0))),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: width / 2, top: 20),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ForgetPassword()),
                        );
                      },
                      child: Text(
                        "FORGOT PASSWORD ?",
                        style: GoogleFonts.raleway(
                            fontSize: 12,
                            color: Color(0xff0abde3),
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                  Center(
                    child: Padding(
                      padding: EdgeInsets.only(top: 50),
                      child: TextButton(
                        // padding: EdgeInsets.only(top: 50),
                        onPressed: null,
                        child: Material(
                          elevation: 10,
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            width: 200,
                            decoration: BoxDecoration(
                                color: Color(0xff0abde3),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                    color: Color(0xff31b8b1).withOpacity(0.5),
                                    width: 2)),
                            height: 40,
                            child: Center(
                              child: ElevatedButton(
                                child: Text('Login'),
                                onPressed: () {
                                  _submit(email, pass);
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Center(
                    child: Text(
                      "Don't have an account ?",
                      style: GoogleFonts.raleway(
                          fontSize: 18,
                          color: Colors.grey[400],
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Center(
                    child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SignUpPage()),
                          );
                        },
                        child: Text(
                          "Sign Up",
                        )),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget input(String hint, bool pass) {
  return Container(
    child: TextFormField(
      decoration: InputDecoration(
          hintText: hint,
          hintStyle: GoogleFonts.raleway(color: Colors.grey),
          contentPadding: EdgeInsets.only(top: 15, bottom: 15),
          enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.grey[300], width: 2.0)),
          focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Color(0xff46ddbf), width: 1.0))),
    ),
  );
}
