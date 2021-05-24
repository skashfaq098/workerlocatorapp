import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workerlocatorapp/models/user_info_model.dart';
import 'package:workerlocatorapp/utils/http_exception.dart';
import 'package:http/http.dart' as http;

class UserInfo extends StatefulWidget {
  final String id;
  const UserInfo({Key key, this.id}) : super(key: key);
  @override
  _UserInfoState createState() => _UserInfoState();
}

class _UserInfoState extends State<UserInfo> {
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

  Future<UserInfoModel> getUserInfo() async {
    try {
      final response = await http.get(
        Uri.https('worker-arfaz-test.herokuapp.com',
            '/api/v1/users/getDetailOfUser/$paraID'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
      );

      final resData = json.decode(response.body);
      print(response.body);

      if (response.statusCode == 200) {
        print(jsonDecode(response.body));

        return userInfoModelFromJson(response.body);
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
              title: Text('SUCCCESS'),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Worker Profile'),
        backgroundColor: Color(0xff0abde3),
      ),
      body: FutureBuilder(
        future: getUserInfo(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
                physics: BouncingScrollPhysics(),
                itemCount: snapshot.data.user.length,
                itemBuilder: (context, index) {
                  var list = new List();
                  for (String ls in snapshot.data.user[index].skills) {
                    list.add(ls);
                  }

                  return Container(
                    margin: EdgeInsets.only(top: 10),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(50),
                          topRight: Radius.circular(50),
                        )),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CircleAvatar(
                          radius: 80.0,
                          backgroundImage:
                              ExactAssetImage('assets/images/as.png'),
                          backgroundColor: Colors.transparent,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          '${snapshot.data.user[index].name}',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 22),
                        ),
                        Text(
                          '${snapshot.data.user[index].email}',
                          style: TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize: 18,
                              color: Color(0xff0abde3)),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Divider(
                          color: Color(0xff0abde3),
                        ),
                        Text(
                          'Skills',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "$list".replaceAll("[", "").replaceAll(']', ""),
                              style: TextStyle(fontSize: 18),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                });
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
