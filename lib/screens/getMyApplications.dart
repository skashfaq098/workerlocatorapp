import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workerlocatorapp/network_module/api_response.dart';
import 'package:workerlocatorapp/providers/getMyApplication_provider.dart';
import 'package:workerlocatorapp/providers/post_provider.dart';
import 'package:workerlocatorapp/screens/detailpost.dart';
// import 'package:workerlocatorapp/widgets/post_detail.dart';

class GetMyApplication extends StatefulWidget {
  @override
  _GetMyApplicationState createState() => _GetMyApplicationState();
}

class _GetMyApplicationState extends State<GetMyApplication> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Applications'),
        backgroundColor: Color(0xff0abde3),
      ),
      body: Container(child: _buildPosts(context)),
    );
  }
}

Widget _buildPosts(BuildContext context) {
  Future<void> _refreshApplications() async {
    Provider.of<ApplicationProvider>(context, listen: false).fetchApplcations();

    print('refreshing stocks...');
  }

  return Consumer<ApplicationProvider>(builder: (context, snapshot, child) {
    if (snapshot.posts.status == Status.COMPLETED) {
      return RefreshIndicator(
        onRefresh: _refreshApplications,
        child: ListView.builder(
          itemCount: snapshot.posts.data.data.applications.length,
          physics: BouncingScrollPhysics(),
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => DetailPost(
                              id: snapshot
                                  .posts.data.data.applications[index].post.id,
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
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          child: Text(
                            '${snapshot.posts.data.data.applications[index].post.title}',
                            style: TextStyle(
                              fontSize: 24,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Container(
                          height: 45,
                          decoration: BoxDecoration(
                            color: Color(0xff0abde3),
                            borderRadius: BorderRadius.all(
                              Radius.circular(10),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              '${snapshot.posts.data.data.applications[index].status}',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Color(0xff0abde3)),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            child: Center(
                              child: Text(
                                '${snapshot.posts.data.data.applications[index].appliedAt}'
                                    .substring(0, 10),
                                style: TextStyle(
                                  fontSize: 24,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
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
            //             AspectRatio(
            //               child: Container(
            //                 //                               decoration: new BoxDecoration(
            //                 //   borderRadius: new BorderRadius.circular(50.0),
            //                 //   color: Color(0xff0abde3),
            //                 // ),
            //                 child: Stack(
            //                   children: [
            //                     Image.network(
            //                         'https://img.freepik.com/free-vector/bird-silhouette-logo-vector-illustration_141216-100.jpg?size=626&ext=jpg',
            //                         fit: BoxFit.cover),
            //                     Container()
            //                   ],
            //                 ),
            //               ),
            //               aspectRatio: 3 / 1,
            //             ),
            //             Padding(
            //               padding: const EdgeInsets.all(16.0),
            //               child: Column(
            //                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //                 crossAxisAlignment: CrossAxisAlignment.start,
            //                 children: [
            //                   Text(
            //                     '${snapshot.posts.data.data.applications[index].appliedAt}',
            //                     style: TextStyle(
            //                       color: Colors.black,
            //                       fontWeight: FontWeight.bold,
            //                       fontSize: 20,
            //                     ),
            //                   ),
            //                   Text(
            //                     '${snapshot.posts.data.data.applications[index].status}',
            //                     style: TextStyle(
            //                       color: Colors.black,
            //                       fontWeight: FontWeight.normal,
            //                       fontSize: 16,
            //                     ),
            //                   ),
            //                   SizedBox(
            //                     height: 5,
            //                   ),
            //                 ],
            //               ),
            //             )
            //           ],
            //         ),
            //       ),
            //     ),
            //   ),
            // );
          },
        ),
      );
    } else if (snapshot.posts.status == Status.LOADING) {
      return Center(
        child: CircularProgressIndicator(),
      );
    } else if (snapshot.posts.status == Status.ERROR) {
      return Text("Error : ${snapshot.posts.message}");
    } else {
      return Text("${snapshot.posts.message}");
    }
  });
}
