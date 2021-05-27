import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:http_parser/http_parser.dart';
import 'package:multi_image_picker2/multi_image_picker2.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workerlocatorapp/helpers/text_form_field_helper.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:dio/dio.dart';
import 'package:workerlocatorapp/screens/sendOTP.dart';
import 'package:workerlocatorapp/utils/http_exception.dart';

class CreatePOst extends StatefulWidget {
  @override
  _CreatePOstState createState() => _CreatePOstState();
}

class _CreatePOstState extends State<CreatePOst> {
  Dio dio = Dio();

  List<Asset> images = <Asset>[];
  String _error = 'No Error Dectected';

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

  developerlibs(
      String title, String location, String contact, String category) async {
    var dio = Dio();
    var map = new Map<String, dynamic>();
    map['title'] = title;
    map['location'] = location;
    map['contact'] = contact;
    map['category'] = category;

    FormData formData = FormData.fromMap({
      "title": title,
      "location": location,
      "contact": contact,
      "category": category,
    });
    var params = {
      "title": title,
      "location": location,
      "contact": contact,
      "category": category,
    };
    dio.options.headers['content-Type'] = 'application/json; charset=UTF-8';
    dio.options.headers["Authorization"] = "Bearer $token";
    Response response = await dio.post(
      "https://worker-arfaz-test.herokuapp.com/api/v1/posts",
      data: jsonEncode(map),
    );
    if (response.statusCode == 201) {
      print(response.data);
    }
  }

  _saveImage(
      String title, String location, String contact, String category) async {
    if (images != null) {
      for (var i = 0; i < images.length; i++) {
        ByteData byteData = await images[i].getByteData();
        List<int> imageData = byteData.buffer.asUint8List();
        MultipartFile multipartFile = MultipartFile.fromBytes(
          imageData,
          filename: images[i].name,
          contentType: MediaType('image', 'jpg'),
        );
        FormData formData = FormData.fromMap({
          "images": multipartFile,
        });

        dio.options.headers['content-Type'] = 'application/json; charset=UTF-8';
        dio.options.headers["Authorization"] = "Bearer $token";
        var response = await dio.post(
            'https://worker-arfaz-test.herokuapp.com/api/v1/posts',
            data: formData);
        if (response.statusCode == 201) {
          print(response);
        } else {
          Map<String, dynamic> _responseMap = json.decode(response.data);
          Scaffold.of(context).showSnackBar(new SnackBar(
            content: new Text(_responseMap['message']),
          ));
        }
      }
    }
  }

  Future<void> loadAssets() async {
    List<Asset> resultList = <Asset>[];
    String error = 'No Error Detected';

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 300,
        enableCamera: true,
        selectedAssets: images,
        cupertinoOptions: CupertinoOptions(
          takePhotoIcon: "chat",
          doneButtonTitle: "Fatto",
        ),
        materialOptions: MaterialOptions(
          actionBarColor: "#abcdef",
          actionBarTitle: "Example App",
          allViewTitle: "All Photos",
          useDetailsView: false,
          selectCircleStrokeColor: "#000000",
        ),
      );
    } on Exception catch (e) {
      error = e.toString();
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      images = resultList;
      _error = error;
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
                      Navigator.pop(context);
                    },
                    child: Text('Okay'))
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
                  ElevatedButton(
                    child: Text("Pick images"),
                    onPressed: loadAssets,
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
