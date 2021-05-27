import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workerlocatorapp/models/detail_post_model.dart';
import 'package:workerlocatorapp/utils/http_exception.dart';
import 'package:carousel_slider/carousel_slider.dart';

class DetailPost extends StatefulWidget {
  final String id;
  const DetailPost({Key key, this.id}) : super(key: key);

  @override
  _DetailPostState createState() => _DetailPostState();
}

class _DetailPostState extends State<DetailPost> {
  String paraID = "";
  String token = "";
  void initState() {
    setState(() {
      paraID = widget.id;
    });
    _loadCounter();

    print(paraID);
    super.initState();
  }

  _loadCounter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      token = (prefs.getString('token') ?? '');
    });
    print(token);
  }

  Future<void> apply() async {
    try {
      final response = await http.post(
        Uri.https('worker-arfaz-test.herokuapp.com', '/api/v1/apply/$paraID'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
      );

      final resData = json.decode(response.body);
      print(response.body);

      if (response.statusCode == 201) {
        print(jsonDecode(response.body));
        showErrorDialog("Applied Successfully");

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
                    child: Text('OK'))
              ],
            ));
  }

  Future<PostDetailModel> getPost() async {
    var url = 'https://worker-arfaz-test.herokuapp.com/api/v1/posts/$paraID';
    var response = await http.get(url);
    if (response.statusCode == 200) {
      print(response.body);
      final post = PostDetailModel.fromJson(jsonDecode(response.body));
      return post;
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Post'),
        backgroundColor: Color(0xff0abde3),
      ),
      body: FutureBuilder(
        future: getPost(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: 1,
              physics: BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                return Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(50),
                        topRight: Radius.circular(50),
                      )),
                  child: Padding(
                    padding: EdgeInsets.all(40),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          child: snapshot.data.data.post.images.isEmpty
                              ? Center(
                                  child: Image.network(
                                      'https://res.cloudinary.com/cloud-arfaz26/image/upload/v1617427778/b65pxkeimgpoy81tituj.jpg',
                                      fit: BoxFit.cover,
                                      width: 1000))
                              : CarouselSlider.builder(
                                  itemCount:
                                      snapshot.data.data.post.images.length,
                                  options: CarouselOptions(
                                    autoPlay: true,
                                    aspectRatio: 2.0,
                                    enlargeCenterPage: true,
                                  ),
                                  itemBuilder: (context, index, realIdx) {
                                    return Container(
                                      child: Center(
                                          child: Image.network(
                                              '${snapshot.data.data.post.images[index]}',
                                              fit: BoxFit.cover,
                                              width: 1000)),
                                    );
                                  }),
                        ),
                        SizedBox(
                          height: 32,
                        ),
                        Center(
                          child: Text(
                            '${snapshot.data.data.post.title}',
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.location_on,
                                color: Color(0xff0abde3),
                              ),
                              Text(
                                '${snapshot.data.data.post.location}',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xff0abde3),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 32,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                height: 45,
                                decoration: BoxDecoration(
                                  color: Color(0xff0abde3),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                ),
                                child: Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.category,
                                        color: Colors.white,
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        '${snapshot.data.data.post.category}'
                                            .toUpperCase(),
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            color: Colors.white),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                child: Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Icon(
                                        Icons.watch_later_outlined,
                                        color: Color(0xff0abde3),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        '${snapshot.data.data.post.postedAt}'
                                            .substring(0, 10),
                                        style: TextStyle(
                                            fontSize: 20,
                                            color: Color(0xff0abde3)),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        Text(
                          "Requirements",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "Previous working experience as a Plumber for (1) year \n successful completion of apprenticeship License to practice profession Applicable knowledge of heating and ventilation systems \n appliances 1 years of experience with plumbing equipment \n Good communication and interpersonal skills \n Great physical condition",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        Row(
                          children: [
                            SizedBox(
                              width: 16,
                            ),
                            Expanded(
                              child: Container(
                                height: 60,
                                decoration: BoxDecoration(
                                  color: Color(0xff0abde3),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                ),
                                child: Center(
                                    child: TextButton(
                                  onPressed: () {
                                    apply();
                                  },
                                  child: Text(
                                    "Apply Now",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                )),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
