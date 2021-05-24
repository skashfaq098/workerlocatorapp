import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workerlocatorapp/models/get_my_applications.dart';
import 'package:workerlocatorapp/models/get_my_post_model.dart';
import 'package:workerlocatorapp/models/post_model.dart';
import 'package:workerlocatorapp/network_module/api_path.dart';
import 'package:workerlocatorapp/network_module/http_client.dart';

class GetMyPostRepo {
  Future<GetMyPost> fetchPost() async {
    String token = "";
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = (prefs.getString('token') ?? '');
    print(token);

    var instance;
    final response = await HttpClient.instance.fetchData(
        APIPathHelper.getValue(APIPath.getMyPosts),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        });

    return getMyPostFromJson(response);
  }
}
