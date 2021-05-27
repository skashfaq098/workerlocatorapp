import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workerlocatorapp/models/detail_post_model.dart';
import 'package:workerlocatorapp/models/getApplicationPost_model.dart';
import 'package:workerlocatorapp/screens/user_info.dart';
import 'package:workerlocatorapp/utils/http_exception.dart';

class GetApplicationForPost extends StatefulWidget {
  final String id;
  const GetApplicationForPost({Key key, this.id}) : super(key: key);

  @override
  _GetApplicationForPostState createState() => _GetApplicationForPostState();
}

class _GetApplicationForPostState extends State<GetApplicationForPost> {
  List<String> finalHired = new List();

  String paraID = "";
  String token = "";
  void initState() {
    _loadCounter();

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

  Future<void> finalHiredPost() async {
    var fList = finalHired.toSet().toList();
    // String jsonTags = jsonEncode(fList);
    final msg = jsonEncode({"completedBy": fList});
    try {
      final response = await http.patch(
          Uri.https('worker-arfaz-test.herokuapp.com',
              '/api/v1/posts/updateCompletedStatus/$paraID'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $token',
          },
          body: msg);

      final resData = json.decode(response.body);
      print(response.body);

      if (response.statusCode == 200) {
        print(jsonDecode(response.body));
        showErrorDialog("Alert");

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

  // Future<void> apply() async {
  //   try {
  //     final response = await http.post(
  //       Uri.https('worker-arfaz-test.herokuapp.com', '/api/v1/apply/$paraID'),
  //       headers: <String, String>{
  //         'Content-Type': 'application/json; charset=UTF-8',
  //         'Authorization': 'Bearer $token',
  //       },
  //     );

  //     final resData = json.decode(response.body);
  //     print(response.body);

  //     if (response.statusCode == 201) {
  //       print(jsonDecode(response.body));
  //       showErrorDialog("Success");

  //       return jsonDecode(response.body);
  //     } else {
  //       throw HttpException(resData['message']);
  //     }
  //   } on HttpException catch (error) {
  //     // print("my exceptioncatch");
  //     showErrorDialog(error.toString());
  //     // print(error.toString());
  //   }
  // }

  // void showErrorDialog(String message) {
  //   showDialog(
  //       context: context,
  //       builder: (ctx) => AlertDialog(
  //             title: Text('SUCCCESS'),
  //             content: Text(message),
  //             actions: [
  //               TextButton(
  //                   onPressed: () {
  //                     Navigator.pop(context);
  //                   },
  //                   child: Text('OK'))
  //             ],
  //           ));
  // }

  Future<GetApplcationForPostModel> getPost() async {
    var url = 'https://worker-arfaz-test.herokuapp.com/api/v1/apply/$paraID';
    headers:
    <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    };
    var response = await http.get(url, headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    });
    if (response.statusCode == 200) {
      print(response.body);
      final post =
          GetApplcationForPostModel.fromJson(jsonDecode(response.body));
      return post;
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
  }

  @override
  Widget build(BuildContext context) {
    var fList = finalHired.toSet().toList();
    String jsonTags = jsonEncode(fList);
    print(jsonTags);
    return Scaffold(
      appBar: AppBar(
        title: Text('Post'),
        backgroundColor: Color(0xff0abde3),
      ),
      body: FutureBuilder(
        future: getPost(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: snapshot.data.data.applications.length,
                    physics: BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => UserInfo(
                                        id: snapshot.data.data
                                            .applications[index].user.id,
                                      )));
                        },
                        child: Container(
                          padding: EdgeInsets.all(24),
                          margin: EdgeInsets.symmetric(vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(
                              Radius.circular(10),
                            ),
                          ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '${snapshot.data.data.applications[index].user.name}',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: Color(0xff0abde3)),
                                  ),
                                  SizedBox(width: 80),
                                  Container(
                                    height: 45,
                                    width: 80,
                                    decoration: BoxDecoration(
                                      color: Color(0xff0abde3),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(10),
                                      ),
                                    ),
                                    child: Center(
                                      child: Text(
                                        '${snapshot.data.data.applications[index].status}',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            color: Colors.white),
                                      ),
                                    ),
                                  ),
                                  Text(
                                    '${snapshot.data.data.applications[index].appliedAt}'
                                        .substring(0, 10),
                                    style: TextStyle(
                                      fontSize: 20,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '${snapshot.data.data.applications[index].user.email}',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: Color(0xff0abde3)),
                                  ),
                                  Container(
                                    child: Row(
                                      children: [
                                        CircleAvatar(
                                            backgroundColor:
                                                finalHired.contains(snapshot
                                                        .data
                                                        .data
                                                        .applications[index]
                                                        .user
                                                        .id)
                                                    ? Colors.green
                                                    : Color(0xff0abde3),
                                            child: IconButton(
                                                icon: finalHired.contains(
                                                        snapshot
                                                            .data
                                                            .data
                                                            .applications[index]
                                                            .user
                                                            .id)
                                                    ? Icon(
                                                        Icons
                                                            .download_done_outlined,
                                                        color: Colors.white,
                                                      )
                                                    : Icon(
                                                        Icons.check,
                                                        color: Colors.white,
                                                      ),
                                                onPressed: () {
                                                  setState(() {
                                                    finalHired.add(snapshot
                                                        .data
                                                        .data
                                                        .applications[index]
                                                        .user
                                                        .id
                                                        .toString());
                                                  });
                                                })),
                                        SizedBox(
                                          width: 15,
                                        ),
                                        CircleAvatar(
                                            backgroundColor: Colors.red,
                                            child: IconButton(
                                                icon: Icon(
                                                  Icons.clear,
                                                  color: Colors.white,
                                                ),
                                                onPressed: () {
                                                  finalHired.remove(snapshot
                                                      .data
                                                      .data
                                                      .applications[index]
                                                      .user
                                                      .id);
                                                })),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );

                      // return Padding(
                      //   padding: EdgeInsets.all(16.0),
                      //   child: ClipRRect(
                      //     borderRadius: BorderRadius.circular(35.0),
                      //     child: Container(
                      //       child: Card(
                      //         color: Color(0xff0abde3)[100],
                      //         // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      //         child: Column(
                      //           mainAxisAlignment: MainAxisAlignment.start,
                      //           crossAxisAlignment: CrossAxisAlignment.start,
                      //           children: <Widget>[
                      //             Padding(
                      //               padding: const EdgeInsets.all(16.0),
                      //               child: Column(
                      //                 mainAxisAlignment:
                      //                     MainAxisAlignment.spaceEvenly,
                      //                 crossAxisAlignment: CrossAxisAlignment.start,
                      //                 children: [
                      //                   Text(
                      //                     '${snapshot.data.data.applications[index].appliedAt}',
                      //                     style: TextStyle(
                      //                       color: Colors.black,
                      //                       fontWeight: FontWeight.bold,
                      //                       fontSize: 20,
                      //                     ),
                      //                   ),
                      //                   Text(
                      //                     '${snapshot.data.data.applications[index].user.name}',
                      //                     style: TextStyle(
                      //                       color: Colors.black,
                      //                       fontWeight: FontWeight.normal,
                      //                       fontSize: 16,
                      //                     ),
                      //                   ),
                      //                   SizedBox(
                      //                     height: 5,
                      //                   ),
                      //                   Row(
                      //                     mainAxisAlignment: MainAxisAlignment.end,
                      //                     children: [
                      //                       Text(
                      //                         '${snapshot.data.data.applications[index].user.email}',
                      //                         style: TextStyle(
                      //                           color: Colors.black,
                      //                           fontWeight: FontWeight.normal,
                      //                           fontSize: 18,
                      //                         ),
                      //                       ),
                      //                     ],
                      //                   ),
                      //                 ],
                      //               ),
                      //             ),
                      //             ElevatedButton(
                      //                 onPressed: () {
                      //                   // apply();
                      //                 },
                      //                 child: Text('Apply'))
                      //           ],
                      //         ),
                      //       ),
                      //     ),
                      //   ),
                      // );
                    },
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                          onPressed: () {
                            finalHiredPost();
                          },
                          child: Text("Hire!")),
                    ),
                  ],
                )
              ],
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
