import 'dart:io';
import 'package:workerlocatorapp/models/post_model.dart';
import 'package:workerlocatorapp/network_module/api_path.dart';
import 'package:workerlocatorapp/network_module/http_client.dart';

class PostRepo {
  Future<PostModel> fetchPostsData() async {
    var instance;
    final response = await HttpClient.instance
        .fetchData(APIPathHelper.getValue(APIPath.posts));
    return postModelFromJson(response);
  }
}
