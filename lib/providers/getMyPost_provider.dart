import 'package:flutter/cupertino.dart';
import 'package:workerlocatorapp/models/get_my_applications.dart';
import 'package:workerlocatorapp/models/get_my_post_model.dart';
import 'package:workerlocatorapp/models/post_model.dart';
import 'package:workerlocatorapp/network_module/api_response.dart';
import 'package:workerlocatorapp/repositories/getMyApplcations_repo.dart';
import 'package:workerlocatorapp/repositories/getMyPost.dart';
import 'package:workerlocatorapp/repositories/posts_repo.dart';

class MyPostProvider extends ChangeNotifier {
  GetMyPostRepo _getPostRepo;
  ApiResponse<GetMyPost> _posts;
  ApiResponse<GetMyPost> get posts => _posts;

  MyPostProvider() {
    _getPostRepo = GetMyPostRepo();
    fetchApplcations();
  }

  fetchApplcations() async {
    _posts = ApiResponse.loading("loading");
    notifyListeners();
    try {
      GetMyPost posts = await _getPostRepo.fetchPost();
      _posts = ApiResponse.completed(posts);
      notifyListeners();
    } catch (e) {
      _posts = ApiResponse.error(e.toString());
      notifyListeners();
    }
  }
}
