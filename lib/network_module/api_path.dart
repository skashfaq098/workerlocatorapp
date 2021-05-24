enum APIPath { posts, getMyApplications, getMyPosts }

class APIPathHelper {
  static String getValue(APIPath path) {
    switch (path) {
      case APIPath.posts:
        return "/posts";
      case APIPath.getMyApplications:
        return "/apply/getMyApplication";
      case APIPath.getMyPosts:
        return "/posts/getMyPosts";
      default:
        return "";
    }
  }
}
