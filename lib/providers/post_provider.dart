import 'package:flutter/cupertino.dart';
import 'package:workerlocatorapp/models/post_model.dart';
import 'package:workerlocatorapp/network_module/api_response.dart';
import 'package:workerlocatorapp/repositories/posts_repo.dart';

class PostProvider extends ChangeNotifier {
  PostRepo _postsRepo;
  ApiResponse<PostModel> _posts;
  ApiResponse<PostModel> get posts => _posts;

  PostProvider() {
    _postsRepo = PostRepo();
    fetchPosts();
  }

  fetchPosts() async {
    _posts = ApiResponse.loading("loading");
    notifyListeners();
    try {
      PostModel posts = await _postsRepo.fetchPostsData();
      _posts = ApiResponse.completed(posts);
      notifyListeners();
    } catch (e) {
      _posts = ApiResponse.error(e.toString());
      notifyListeners();
    }
  }
}
