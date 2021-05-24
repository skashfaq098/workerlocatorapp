import 'package:flutter/cupertino.dart';
import 'package:workerlocatorapp/models/get_my_applications.dart';
import 'package:workerlocatorapp/models/post_model.dart';
import 'package:workerlocatorapp/network_module/api_response.dart';
import 'package:workerlocatorapp/repositories/getMyApplcations_repo.dart';
import 'package:workerlocatorapp/repositories/posts_repo.dart';

class ApplicationProvider extends ChangeNotifier {
  GetMyApplicationsRepo _getApplicationRepo;
  ApiResponse<GetMyApplications> _posts;
  ApiResponse<GetMyApplications> get posts => _posts;

  ApplicationProvider() {
    _getApplicationRepo = GetMyApplicationsRepo();
    fetchApplcations();
  }

  fetchApplcations() async {
    _posts = ApiResponse.loading("loading");
    notifyListeners();
    try {
      GetMyApplications posts = await _getApplicationRepo.fetchApplications();
      _posts = ApiResponse.completed(posts);
      notifyListeners();
    } catch (e) {
      _posts = ApiResponse.error(e.toString());
      notifyListeners();
    }
  }
}
