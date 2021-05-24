import 'package:shared_preferences/shared_preferences.dart';
import 'package:workerlocatorapp/helpers/text_form_field_helper.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:workerlocatorapp/screens/sendOTP.dart';
import 'dart:convert';

import 'package:workerlocatorapp/utils/http_exception.dart';

class CreatePOst extends StatefulWidget {
  @override
  _CreatePOstState createState() => _CreatePOstState();
}

class _CreatePOstState extends State<CreatePOst> {
  String token = "";
  void initState() {
    super.initState();
    _loadCounter();
  }

  _loadCounter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      token = (prefs.getString('token') ?? '');
    });
  }

  Future<void> createPost(
    String title,
    String location,
    String contact,
    String category,
  ) async {
    try {
      final response = await http.post(
        Uri.https('worker-arfaz-test.herokuapp.com', '/api/v1/posts'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(<String, String>{
          "title": title,
          "location": location,
          "contact": contact,
          "category": category,
        }),
      );

      final resData = json.decode(response.body);
      print(response.body);

      if (response.statusCode == 201) {
        print(jsonDecode(response.body));
        showErrorDialog("Success");

        return jsonDecode(response.body);
      } else {
        throw HttpException(resData['message']);
      }
    } on HttpException catch (error) {
      // print("my exceptioncatch");
      showErrorDialog(error.toString());
      // print(error.toString());
    }
  }

  void showErrorDialog(String message) {
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              title: Text('Alert'),
              content: Text(message),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SendOTP()),
                      );
                    },
                    child: Text('Verify Phone'))
              ],
            ));
  }

  final _formKey = GlobalKey<FormState>();
  String title;
  String location;
  String contact;
  String category;
  String email;
  final _titleController = TextEditingController();
  final _locationController = TextEditingController();
  final _contactController = TextEditingController();
  final _categoryController = TextEditingController();
  final _emailController = TextEditingController();
  Future<http.Response> createAlbum(String title) {
    return http.post(
      Uri.https('jsonplaceholder.typicode.com', 'albums'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'title': title,
      }),
    );
  }

  void _performLogin() {
    String title = _titleController.text;
    String location = _locationController.text;
    String contact = _contactController.text;
    String category = _categoryController.text;
    String email = _emailController.text;

    print('login attempt: $title with $location $contact $category $email');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('Create Post'),
          elevation: 0.0,
          backgroundColor: Color(0xff0abde3)),
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
                  RichText(
                      text: TextSpan(
                    text: 'Create Post',
                  )),
                  SizedBox(
                    height: 25,
                  ),
                  TextFormFieldHelper(
                    controller: _titleController,
                    labelText: "Title",
                    prefixIconData: Icons.title,
                    textInputType: TextInputType.name,
                    onChanged: (value) => title = value,
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  TextFormFieldHelper(
                    controller: _locationController,
                    labelText: "Location",
                    prefixIconData: Icons.location_city,
                    textInputType: TextInputType.name,
                    onChanged: (value) => location = value,
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  TextFormFieldHelper(
                    controller: _contactController,
                    labelText: "Contact",
                    prefixIconData: Icons.contact_phone_rounded,
                    textInputType: TextInputType.name,
                    onChanged: (value) => contact = value,
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  TextFormFieldHelper(
                    controller: _categoryController,
                    labelText: "Category",
                    prefixIconData: Icons.category,
                    textInputType: TextInputType.name,
                    onChanged: (value) => category = value,
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Color(0xff0abde3),
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          child: Text(
                            'SELECT IMAGES..',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        setState(() {
                          createPost(title, location, contact, category);
                        });
                      },
                      child: Text('Post')),
                ],
              ),
            ),
          ),
        ),
      )),
    );
  }
}
