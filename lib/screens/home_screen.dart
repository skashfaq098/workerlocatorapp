import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workerlocatorapp/models/getmydetails.dart';
import 'package:workerlocatorapp/providers/auth.dart';
import 'package:workerlocatorapp/screens/create_post.dart';
import 'package:workerlocatorapp/screens/getMyApplications.dart';
import 'package:workerlocatorapp/screens/getMyPost.dart';
import 'package:workerlocatorapp/screens/posts_screen.dart';
import 'package:workerlocatorapp/screens/sendOTP.dart';
import 'package:workerlocatorapp/screens/userprofile.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String userEmail = "";
  String token = "";
  String tokenNew =
      "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjYwNmYxZGVhZDNmZjcyMDAxNWI5MTM2MiIsImlhdCI6MTYyMDUwODY1NSwiZXhwIjoxNjI4Mjg0NjU1fQ.SMaVz4AMglACYo0hqzEh0gWm40Hv1zrIeUlGurc6wJA";
  @override
  void initState() {
    super.initState();
    _loadCounter();
    // getMyDetail();
  }

  _loadCounter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userEmail = (prefs.getString('usersEmail') ?? '');
      token = (prefs.getString('token') ?? '');
    });
  }

  Future<GetMyDetail> getDetail() async {
    var url =
        'https://worker-arfaz-test.herokuapp.com/api/v1/users/getMyDetails';
    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      print(response.body);
      return getMyDetailFromJson(response.body);
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
  }

  // Future<GetMyDetail> getMyDetail() async {
  //   final response = await http.get(
  //     Uri.https(
  //         'worker-arfaz-test.herokuapp.com', '/api/v1/users/getMyDetails'),
  //     headers: <String, String>{
  //       'Content-Type': 'application/json; charset=UTF-8',
  //       'Authorization': 'Bearer $token',
  //     },
  //   );

  //   final resData = json.decode(response.body);
  //   print(response.body);

  //   if (response.statusCode == 200) {
  //     print(jsonDecode(response.body));
  //   }
  //   return GetMyDetail.fromJson(jsonDecode(response.body));
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('WorkerLocator'),
        backgroundColor: Color(0xff0abde3),
      ),
      drawer: Drawer(
        child: FutureBuilder(
          future: getDetail(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              return ListView(
                children: [
                  UserAccountsDrawerHeader(
                    decoration: BoxDecoration(color: Color(0xff0abde3)),
                    accountName: Text("${snapshot.data.data.user.name}"),
                    accountEmail: Text("${snapshot.data.data.user.email}"),
                    currentAccountPicture: CircleAvatar(
                      backgroundColor:
                          Theme.of(context).platform == TargetPlatform.iOS
                              ? Color(0xff0abde3)
                              : Colors.white,
                      child: Text(
                        "${snapshot.data.data.user.name}"
                            .substring(0, 1)
                            .toUpperCase(),
                        style: TextStyle(fontSize: 40.0),
                      ),
                    ),
                  ),
                  // FutureBuilder(
                  //   future: getMyDetail(),
                  //   builder: (ctx, snapshot) => snapshot.hasData
                  //       ? ListTile(
                  //           title: Text("Create Post"),
                  //           trailing: Icon(Icons.add_circle_outline),
                  //           onTap: () {
                  //             Navigator.of(context).pop();
                  //             Navigator.of(context).push(MaterialPageRoute(
                  //                 builder: (BuildContext context) => CreatePOst()));
                  //           },
                  //         )
                  //       : ListTile(
                  //           title: Text("Edit Profile"),
                  //           trailing: Icon(Icons.edit),
                  //           onTap: () {
                  //             Navigator.of(context).pop();
                  //             Navigator.of(context).push(MaterialPageRoute(
                  //                 builder: (BuildContext context) => ProfilePage()));
                  //           },
                  //         ),
                  // ),
                  snapshot.data.data.user.role == "recruiter"
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ListTile(
                              title: Text("Create Post"),
                              trailing: Icon(
                                Icons.add_circle_outline,
                                color: Color(0xff0abde3),
                              ),
                              onTap: () {
                                Navigator.of(context).pop();
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        CreatePOst()));
                              },
                            ),
                            ListTile(
                              title: Text("Edit Profile"),
                              trailing:
                                  Icon(Icons.edit, color: Color(0xff0abde3)),
                              onTap: () {
                                Navigator.of(context).pop();
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        ProfilePage()));
                              },
                            ),
                            ListTile(
                              title: Text("My Posts"),
                              trailing:
                                  Icon(Icons.edit, color: Color(0xff0abde3)),
                              onTap: () {
                                Navigator.of(context).pop();
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        GetMyPost()));
                              },
                            ),
                            ListTile(
                              title: Text("Verify Number"),
                              trailing:
                                  Icon(Icons.edit, color: Color(0xff0abde3)),
                              onTap: () {
                                Navigator.of(context).pop();
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        SendOTP()));
                              },
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                ListTile(
                                  title: Text("Logout"),
                                  trailing: Icon(Icons.logout,
                                      color: Color(0xff0abde3)),
                                  onTap: () {
                                    Provider.of<Auth>(context, listen: false)
                                        .logout();
                                  },
                                ),
                              ],
                            ),
                          ],
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ListTile(
                              title: Text("Edit Profile"),
                              trailing:
                                  Icon(Icons.edit, color: Color(0xff0abde3)),
                              onTap: () {
                                Navigator.of(context).pop();
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        ProfilePage()));
                              },
                            ),
                            ListTile(
                              title: Text("My Applcations"),
                              trailing:
                                  Icon(Icons.edit, color: Color(0xff0abde3)),
                              onTap: () {
                                Navigator.of(context).pop();
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        GetMyApplication()));
                              },
                            ),
                            ListTile(
                              title: Text("Verify Number"),
                              trailing:
                                  Icon(Icons.edit, color: Color(0xff0abde3)),
                              onTap: () {
                                Navigator.of(context).pop();
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        SendOTP()));
                              },
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                ListTile(
                                  title: Text("Logout"),
                                  trailing: Icon(Icons.logout,
                                      color: Color(0xff0abde3)),
                                  onTap: () {
                                    Provider.of<Auth>(context, listen: false)
                                        .logout();
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                ],
              );
            }
            return Center(child: CircularProgressIndicator());
          },
        ),
      ),
      body: Post(),
    );
  }
}
