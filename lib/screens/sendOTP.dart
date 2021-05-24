import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workerlocatorapp/providers/auth.dart';
import 'package:workerlocatorapp/screens/verify_otp.dart';
import 'package:workerlocatorapp/utils/http_exception.dart';

class SendOTP extends StatefulWidget {
  @override
  _SendOTPState createState() => _SendOTPState();
}

class _SendOTPState extends State<SendOTP> {
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

  Future _sendOtp(String phone) async {
    try {
      await Provider.of<Auth>(context, listen: false).sendOTP(phone);
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

  final _formKey = GlobalKey<FormState>();
  String phone;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Send OTP'),
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
                      onChanged: (newValue) => phone = newValue,
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
                          _sendOtp(phone);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => VerifyOTP()),
                          );
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
