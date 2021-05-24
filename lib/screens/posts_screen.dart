import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workerlocatorapp/network_module/api_response.dart';
import 'package:workerlocatorapp/providers/post_provider.dart';
import 'package:workerlocatorapp/screens/detailpost.dart';
// import 'package:workerlocatorapp/widgets/post_detail.dart';

class Post extends StatefulWidget {
  @override
  _PostState createState() => _PostState();
}

class _PostState extends State<Post> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(child: _buildPosts(context)),
    );
  }
}

Widget _buildPosts(BuildContext context) {
  Future<void> _refreshPost() async {
    Provider.of<PostProvider>(context, listen: false).fetchPosts();

    print('refreshing stocks...');
  }

  return Consumer<PostProvider>(builder: (context, snapshot, child) {
    if (snapshot.posts.status == Status.COMPLETED) {
      return RefreshIndicator(
        onRefresh: _refreshPost,
        child: ListView.builder(
          itemCount: snapshot.posts.data.data.posts.length,
          scrollDirection: Axis.vertical,
          physics: BouncingScrollPhysics(),
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => DetailPost(
                              id: snapshot.posts.data.data.posts[index].id,
                            )));
              },
              child: Padding(
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
                          AspectRatio(
                            child: Image.network(
                                snapshot.posts.data.data.posts[index].images
                                        .isEmpty
                                    ? 'https://res.cloudinary.com/cloud-arfaz26/image/upload/v1617427778/b65pxkeimgpoy81tituj.jpg'
                                    : '${snapshot.posts.data.data.posts[index].images[0]}',
                                fit: BoxFit.cover),
                            aspectRatio: 2 / 1,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      ' ${snapshot.posts.data.data.posts[index].title}.'
                                          .toUpperCase(),
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                      ),
                                    ),
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
                                          '${snapshot.posts.data.data.posts[index].category}'
                                              .toUpperCase(),
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
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.location_on,
                                      color: Color(0xff0abde3),
                                    ),
                                    Text(
                                      '${snapshot.posts.data.data.posts[index].location}',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.normal,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      '${snapshot.posts.data.data.posts[index].contact}',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.normal,
                                        fontSize: 18,
                                      ),
                                    ),
                                    Icon(
                                      Icons.phone,
                                      color: Color(0xff0abde3),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
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
