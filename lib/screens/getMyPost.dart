import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workerlocatorapp/network_module/api_response.dart';
import 'package:workerlocatorapp/providers/getMyApplication_provider.dart';
import 'package:workerlocatorapp/providers/getMyPost_provider.dart';
import 'package:workerlocatorapp/providers/post_provider.dart';
import 'package:workerlocatorapp/screens/detailpost.dart';
import 'package:workerlocatorapp/repositories/getMyPost.dart';
import 'package:workerlocatorapp/screens/getApplicationForPost.dart';
// import 'package:workerlocatorapp/widgets/post_detail.dart';

class GetMyPost extends StatefulWidget {
  @override
  _GetMyPostState createState() => _GetMyPostState();
}

class _GetMyPostState extends State<GetMyPost> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Posts'),
        backgroundColor: Color(0xff0abde3),
      ),
      body: Container(child: _buildPosts(context)),
    );
  }
}

Widget _buildPosts(BuildContext context) {
  Future<void> _refreshPost() async {
    Provider.of<MyPostProvider>(context, listen: false).fetchApplcations();

    print('refreshing stocks...');
  }

  return Consumer<MyPostProvider>(builder: (context, snapshot, child) {
    if (snapshot.posts.status == Status.COMPLETED) {
      return RefreshIndicator(
        onRefresh: _refreshPost,
        child: ListView.builder(
          itemCount: snapshot.posts.data.data.posts.length,
          physics: AlwaysScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return Padding(
              padding: EdgeInsets.all(16.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(35.0),
                child: Container(
                  child: Card(
                    color: Colors.white,
                    // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${snapshot.posts.data.data.posts[index].title}',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                              Text(
                                '${snapshot.posts.data.data.posts[index].location}',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 16,
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                GetApplicationForPost(
                                                  id: snapshot.posts.data.data
                                                      .posts[index].id,
                                                )));
                                  },
                                  child: Text('View Applications'))
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            );
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
